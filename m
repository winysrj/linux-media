Return-path: <mchehab@pedra>
Received: from bamako.nerim.net ([62.4.17.28]:63541 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab1AaLQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 06:16:36 -0500
From: Thierry LELEGARD <tlelegard@logiways.com>
To: Andreas Oberritter <obi@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: RE: [linux-media] API V3 vs S2API behavior difference in reading
 tuning  parameters
Date: Mon, 31 Jan 2011 11:09:23 +0000
Message-ID: <BA2A2355403563449C28518F517A3C4805AB8958@titan.logiways-france.fr>
Content-Language: fr-FR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> From: Andreas Oberritter [mailto:obi@linuxtv.org]
> Sent: Wednesday, January 19, 2011 7:12 PM
> To: Thierry LELEGARD
> Cc: linux-media@vger.kernel.org; Devin Heitmueller
> Subject: Re: [linux-media] API V3 vs SAPI behavior difference in reading tuning
> parameters
> 
> On 01/19/2011 06:03 PM, Thierry LELEGARD wrote:
> > OK, then what? Is the S2API behavior (returning cached - but incorrect - tuning
> > parameter values) satisfactory for everyone or shall we adapt S2API to mimic the
> > API V3 behavior (return the actual tuning parameter values as automatically
> > adjusted by the driver)?
> 
> To quote myself:
> 
> if that's still the case in Git (I didn't verify), then it should indeed
> be changed to behave like v3 does. Would you mind to submit a patch, please?
> 
> I haven't heard any objections, so just go on if you want. Otherwise I
> might prepare a patch once time permits.
> 
> Regards,
> Andreas

Sorry for the late follow-up due to busy projects.

Yes, the latest git suffers from the same problem. The values returned
by FE_GET_PROPERTY (S2API) are sometimes wrong while the values returned
by FE_GET_FRONTEND (API V3) are correct, or at least as correct as the
driver can say.

Looking at the code in dvb_frontend.c, the reasons are pretty obvious.
FE_GET_PROPERTY directly returns cached values (at S2API level) while
FE_GET_FRONTEND asks the driver to return values. When the application
sends "auto" values (xxx_AUTO) or even wrong values that the driver is
able to correct, FE_GET_PROPERTY returns the same auto or wrong values
while FE_GET_FRONTEND returns the values that the driver has discovered
or decided to apply.

FE_GET_PROPERTY returning only cached values:

static int dtv_property_process_get(struct dvb_frontend *fe,
                                    struct dtv_property *tvp,
                                    struct file *file)
{
        int r = 0;

        /* Allow the frontend to validate incoming properties */
        if (fe->ops.get_property)
                r = fe->ops.get_property(fe, tvp);

        if (r < 0)
                return r;

        switch(tvp->cmd) {
        case DTV_FREQUENCY:
                tvp->u.data = fe->dtv_property_cache.frequency;
                break;
        case DTV_MODULATION:
                tvp->u.data = fe->dtv_property_cache.modulation;
                break;
        case DTV_BANDWIDTH_HZ:
                tvp->u.data = fe->dtv_property_cache.bandwidth_hz;
                break;
        ...etc...

FE_GET_FRONTEND asking the driver to return its own values:

static int dvb_frontend_ioctl_legacy(struct file *file,
                        unsigned int cmd, void *parg)
{
    ...etc...
        case FE_GET_FRONTEND:
                if (fe->ops.get_frontend) {
                        memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
                        err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
                }
                break;
        ...etc...

How to fix this?

For legacy drivers, it is still possible to invoke driver's get_frontend
to get the correct values in a struct dvb_frontend_parameters. But, for
new drivers and new protocols for which some properties cannot be emulated
in a struct dvb_frontend_parameters, I do not see any driver callback to
"ask for the value of a property". The callback get_property seems to be
here to "validate" the usage of a property in the driver's context. As you
can see, dtv_property_process_get simply checks the returned value but
ignore a possible update of the struct dtv_property. Moreover, I have
checked the code of a few drivers implementing get_property and the
general idea is usually simply "return 0".

I do think that this problem is a functional regression from API V3 for
most users. But I do not see an obvious and general way of fixing it.
Any idea ?

Best regards,
-Thierry
