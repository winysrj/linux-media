Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40120 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0EISqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 14:46:30 -0400
Received: by bwz19 with SMTP id 19so1391320bwz.21
        for <linux-media@vger.kernel.org>; Sun, 09 May 2010 11:46:28 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Tim Coote <tim+vger.kernel.org@coote.org>
Subject: Re: setting up a tevii s660
Date: Sun, 9 May 2010 21:46:23 +0300
Cc: linux-media@vger.kernel.org
References: <E23F27D7-CF5B-4F6B-9656-EB63E7005BD0@coote.org>
In-Reply-To: <E23F27D7-CF5B-4F6B-9656-EB63E7005BD0@coote.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201005092146.23620.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 мая 2010 02:07:38 Tim Coote wrote:
> Hullo
> I've been struggling with this for a couple of days. I have checked
> archives, but missed anything useful.
>
> I've got a tevii s660 (dvbs2 via usb). It works with some limitations
> on windows xp (I cannot get HD signals decoded, but think that's a
> limitation of the software that comes on the CD).
>
> I'm trying to get this working on Linux. I've tried VMs based on
> fedora 12 and mythbuntu (VMWare Fusion on a MacBookPro, both based on
> kernel 2.6.32), using the drivers from tevii's site
> (www.tevii.com/support.asp) . these drivers are slightly modified versions
> of the v4l tip - but don't appear to be modified where I've not yet managed
> to get the
> drivers working :-(.  Mythbuntu seems to be closest to working.
> Goodness knows how tevii tested the code, but it doesn't seem to work
> as far as I can see.  My issues could just be down to using a VM.
>
> I believe that I need to load up the modules ds3000 and dvb-usb-
> dw2102, + add a rule to /etc/udev/rules.d and a script to /etc/udev/
> scripts.
>
> I think that I must be missing quite a lot of context, tho'. When I
> look at the code in dw2102.c, which seems to support the s660, the bit
> that downloads the firmware looks broken and if I add a default clause
> to the switch that does the download, the s660's missed the download
> process.  This could be why when I do get anything out of the device
> it looks like I'm just getting repeated bytes (the same value
> repeated, different values at different times, sometimes nothing).
> I'm finding it non-trivial working out the call sequences of the code
> or devising repeatable tests.
>
> Can anyone kick me off on getting this working? I'd like to at least
> get to the point where scandvb can tune the device. It does look like
> some folk have had success in the past, but probably with totally
> different codebase (there are posts that refer to the teviis660
> module, which I cannot find).
>
> Any pointer gratefully accepted. I'll feed back any success if I can
> be pointed at where to drop document it.
>
> tia
>
> Tim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi!
Read this:
http://forum.free-x.de/wbb/index.php?page=Thread&threadID=601&pageNo=6
Useful to translate from Russian:
http://babelfish.yahoo.com/translate_txt
Best regards
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
