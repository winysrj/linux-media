Return-path: <linux-dvb-bounces@linuxtv.org>
Date: Sun, 3 Feb 2008 18:05:06 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Bodo Eggert <7eggert@gmx.de>
In-Reply-To: <E1JLi7A-0003bn-5Y@be1.7eggert.dyndns.org>
Message-ID: <Pine.LNX.4.64.0802031802530.25263@pub6.ifh.de>
References: <9Sxa6-6B-7@gated-at.bofh.it>
	<E1JLi7A-0003bn-5Y@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
	Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] [PATCH]
 [rivers/media/video/tvaudio.c] add parentheses
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

On Sun, 3 Feb 2008, Bodo Eggert wrote:

> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
> > '!' has a higher priority than '&': bitanding has no effect.
> 
> > +++ b/drivers/media/video/tvaudio.c
> > @@ -1571,14 +1571,14 @@ static int tvaudio_get_ctrl(struct CHIPSTATE *chip,
> >  ctrl->value=chip->muted;
> >  return 0;
> >  case V4L2_CID_AUDIO_VOLUME:
> > -             if (!desc->flags & CHIP_HAS_VOLUME)
> > +             if (!(desc->flags & CHIP_HAS_VOLUME))
> 
> This is a cosmetic change, because:
> 
> !1100101 & 0000100 == 0011010 & 0000100 == 0 /* false */
> !(1100101 & 0000100) == !0000100 == 0 /* false */
> 
> !1100001 & 0000100 == 0011110 & 0000100 == 0000100 /* non-false */
> !(1100001 & 0000100) == !0000000 == 1 /* non-false */
> 
> 
> OTOH, your change may result in better code by using a negated jump instead of
> explicitely negating the value.

If I'm not totally wrong, ! is negating integers: !123 == 0. At least I 
hope that, otherwise I have to go through a lot of code ;)

Your interpretation of ! is actually achieved by using ~ .

Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
