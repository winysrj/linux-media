Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43087 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbdKYLI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Nov 2017 06:08:26 -0500
Date: Sat, 25 Nov 2017 09:08:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dvbv5-scan: Missing NID, TID, and RID in VDR channel output
Message-ID: <20171125090819.1a55e11a@vento.lan>
In-Reply-To: <f65773a8-603a-ba10-b420-896efc70c26a@googlemail.com>
References: <f65773a8-603a-ba10-b420-896efc70c26a@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Wed, 22 Nov 2017 20:50:56 +0100
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello Mauro and list,
> 
> since some days my region in Germany finally got DVB-T2 coverage.
> Something in the broadcasted tabled makes w_scan only find a subset each
> time. dvbv5-scan is somewhat more reliable.  But with the VDR compatible
> channel list exported from dvbv5-scan I cannot make VDR produce any EPG.
> >From skimming over the VDR code I think this is due to missing NID and TID.
> 
> The upper one is from dvbv5-scan, the lower one from w_scan:
> 
> >                                                                       VPID    APID                   TPID  CA SID  NID   TID    RID
> > arte HD    :618000:B8 C999 D999 G19128 I999 M999 S1 T16 Y0   :T:27500 :210    :220,221               :0    :0 :770 :0    :0     :0
> > arte HD;ARD:618000:B8      D0   G19256           S1 T32 Y0 P0:T:27500 :210=36 :220=deu@17,221=fra    :230  :0 :770 :8468 :15106 :0
> 
> Mauro, do you think it would be possible to parse / output NID, TID, and
> RID from dvbv5_scan? It would greatly improve usability.

It is possible. Not sure how much efforts it would take. Could you please
send me, in priv, a capture of ~30-60 seconds of a recent DVB-T2 channel
in Germany with those fields, and the corresponding output from w_scan,
for all channels at the same frequency?

I'll use it to test it with my RF generator here, and see if I can tweak
dvbv5-scan to produce the same output.

The syntax to capture the full MPEG-TS is:

	$ dvbv5-zap -P -o channel.ts -t 60 scan_file.conf


Even 60seconds produce a big file, so you'll likely need to store 
somewhere (like Google Drive) and send me a link to it.

-- 
Thanks,
Mauro
