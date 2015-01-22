Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48758 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbbAVNhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 08:37:40 -0500
Message-ID: <1421933856.2594.0.camel@xs4all.nl>
Subject: Re: [PATCH] Si2168: increase timeout to fix firmware loading
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Olli Salonen <olli.salonen@iki.fi>
Date: Thu, 22 Jan 2015 14:37:36 +0100
In-Reply-To: <54C0CB1E.2040502@iki.fi>
References: <1418027444-4718-1-git-send-email-gtmkramer@xs4all.nl>
	 <5485E572.9010801@iki.fi> <548D747E.6060404@iki.fi>
	 <54C0CB1E.2040502@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2015-01-22 at 12:04 +0200, Antti Palosaari wrote:
> I will make pull request for that as that is still on patchwork.... :(

Thanks, I was about to send in a resend.

Jurgen

> Antti
> 
> On 12/14/2014 01:29 PM, Antti Palosaari wrote:
> > On 12/08/2014 07:52 PM, Antti Palosaari wrote:
> >> On 12/08/2014 10:30 AM, Jurgen Kramer wrote:
> >>> Increase si2168 cmd execute timeout to prevent firmware load failures.
> >>> Tests
> >>> shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw'
> >>> firmware.
> >>> Increase timeout to a safe value of 70ms.
> >>>
> >>> Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
> >> Reviewed-by: Antti Palosaari <crope@iki.fi>
> >> Cc: <stable@vger.kernel.org> # v3.17+
> >
> > Cc: <stable@vger.kernel.org> # v3.16+
> >
> > Changed from stable 3.17+ to 3.16+ as I found that PCTV 292e timeouts
> > too when tuning DVB-T2, not always, but from time to time...
> >
> > Antti
> >
> >>
> >> That must go stable 3.17.
> >>
> >> Antti
> >>
> >>> ---
> >>>   drivers/media/dvb-frontends/si2168.c | 2 +-
> >>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/media/dvb-frontends/si2168.c
> >>> b/drivers/media/dvb-frontends/si2168.c
> >>> index ce9ab44..d2f1a3e 100644
> >>> --- a/drivers/media/dvb-frontends/si2168.c
> >>> +++ b/drivers/media/dvb-frontends/si2168.c
> >>> @@ -39,7 +39,7 @@ static int si2168_cmd_execute(struct si2168 *s,
> >>> struct si2168_cmd *cmd)
> >>>
> >>>       if (cmd->rlen) {
> >>>           /* wait cmd execution terminate */
> >>> -        #define TIMEOUT 50
> >>> +        #define TIMEOUT 70
> >>>           timeout = jiffies + msecs_to_jiffies(TIMEOUT);
> >>>           while (!time_after(jiffies, timeout)) {
> >>>               ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
> >>>
> >>
> >
> 


