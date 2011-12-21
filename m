Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:32866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1LUIon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 03:44:43 -0500
Received: by werm1 with SMTP id m1so2521874wer.19
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 00:44:42 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driv
Date: Wed, 21 Dec 2011 09:44:25 +0100
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <4EE929D5.6010106@iki.fi> <4EF0CD63.20003@iki.fi> <4EF0CF4A.8050500@redhat.com>
In-Reply-To: <4EF0CF4A.8050500@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112210944.26170.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 20 December 2011 19:09:14 Mauro Carvalho Chehab wrote:
> On 20-12-2011 16:01, Antti Palosaari wrote:
> > On 12/20/2011 07:16 PM, Antti Palosaari wrote:
> >> On 12/20/2011 06:25 PM, Patrick Boettcher wrote:
> >>> Hi all,
> >>> 
> >>> On Tuesday 20 December 2011 16:42:53 Antti Palosaari wrote:
> >>>> Adding those to API is not mission impossible. Interleaver is
> >>>> only new parameter and all the rest are just extending values.
> >>>> But my time is limited... and I really would like to finally
> >>>> got Anysee smart card reader integrated to USB serial first.
> >>> 
> >>> And if it is added we should not forget to discuess whether
> >>> DMB-TH is the "right" name. (If this has already been addressed
> >>> in another thread please point me to it).
> >>> 
> >>> I know this standard under at least 2 different names: CTTB and
> >>> DTMB.
> >>> 
> >>> Which is the one to choose?
> >> 
> >> Yes, there is many names and it is not even clear for me what are
> >> differences between names. I called it DMB-TH since existing
> >> Kernel drivers have selected that name.
> >> 
> >> http://en.wikipedia.org/wiki/CMMB
> >> http://en.wikipedia.org/wiki/DTMB
> >> http://en.wikipedia.org/wiki/Digital_Multimedia_Broadcasting
> >> http://en.wikipedia.org/wiki/Digital_Terrestrial_Multimedia_Broadc
> >> ast
> >> 
> >> CMMB
> >> CTTB
> >> DTMB (DTMB-T/H, DMB-T/H)
> >> DMB (T-DMB)
> > 
> > DMB seems to be much different so drop it out. DTMB seems to be
> > official term for DMB-T/H. CMMB seems to be for small devices
> > (mobile), maybe subset of DTMB. Finally I have CTTB and DTMB which
> > seems to be equivalents. DTMB is more common.
> > 
> > So I end up for the DTMB. I give my vote for that.

CMMB has nothing to do with DTMB/CTTB. It modulations parameters and 
physical/link layers are completely different compared to CMMB.

I'll vote for CTTB as this is the (latest) official name. At least this 
is what DiBcom's Chinese representatives state.

Maybe there are some Chinese on this list to enlighten this situation?

--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
