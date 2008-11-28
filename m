Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASIpbc1006493
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 13:51:37 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASIpQ3O021086
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 13:51:26 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: David Brownell <david-b@pacbell.net>
Date: Sat, 29 Nov 2008 00:21:07 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E904ECE6@dbde02.ent.ti.com>
In-Reply-To: <200811280852.22711.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"davinci-linux-open-source-bounces@linux.davincidsp.com"
	<davinci-linux-open-source-bounces@linux.davincidsp.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 2/2] TVP514x Driver with Review comments fixed
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Friday, November 28, 2008 10:22 PM
> To: Hiremath, Vaibhav
> Cc: video4linux-list@redhat.com; davinci-linux-open-source-
> bounces@linux.davincidsp.com; linux-omap@vger.kernel.org; Jadav,
> Brijesh R; Shah, Hardik; Hadli, Manjunath; R, Sivaraj; Karicheri,
> Muralidharan
> Subject: Re: [PATCH 2/2] TVP514x Driver with Review comments fixed
> 
> On Friday 28 November 2008, hvaibhav@ti.com wrote:
> > +       for (; next->token != TOK_TERM; next++) {
> > +               if (next->token == TOK_DELAY) {
> > +                       schedule_timeout(msecs_to_jiffies(next-
> >val));
> 
> 			msleep(next->val);
> 
> would be clearer and more conventional.
> 
> 
[Hiremath, Vaibhav] Yes, verified the implementation of msleep. It does the same thing what I am doing. Good to change.

> > +                       continue;
> > +               }
> 
> 
> > +static int
> > +tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id)
> > +{
> > +       struct tvp514x_decoder *decoder = &tvp514x_dev;
> > +       int err;
> > +
> > +       if (i2c_get_clientdata(client))
> > +               return -EBUSY;
> > +
> 
> When no driver is bound to the client, clientdata is undefined.
> So just strike that ... you can rely on probe() only being
> called on un-bound drivers.
> 
> 
[Hiremath, Vaibhav] I am not an expert in I2C, will get back to you on this.

> I still don't see any post-reset chip init being done.  The data
> sheets for the tvp5146 and tvp5147 say that after reset, some
> commands must be sent ... that's not being done here.  Are you
> assuming perhaps tvp5146m2 and tvp5147m1, although they are not
> listed as chips supported by this driver?  (That's a repeat of
> a previous review comment, which garnered no response, so the
> $SUBJECT is inaccurate:  at least some review comments have not
> yet been addressed...)
> 
[Hiremath, Vaibhav] Thanks pointing me to this, I was not aware of this thing. Two same ID chips (0x46) require different reset sequence. May be overlooked this part due to ID.

Will have to now think how to differentiate between these two chips and handle this sequence.

> - Dave
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
