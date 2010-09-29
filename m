Return-path: <mchehab@pedra>
Received: from psmtp30.wxs.nl ([195.121.247.32]:51565 "EHLO psmtp30.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab0I2WIz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 18:08:55 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp30.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9J00MQB46TVP@psmtp30.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 30 Sep 2010 00:08:54 +0200 (MEST)
Date: Thu, 30 Sep 2010 00:08:52 +0200
From: Jan Hoogenraad <jan-verisign@hoogenraad.net>
Subject: Several linux-release dependent fixes (new and old)
In-reply-to: <201009291911.o8TJBNCr042424@smtp-vbr13.xs4all.nl>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Message-id: <4CA3B8F4.60300@hoogenraad.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Vg22WM+pY9etOjiNFwTx7A)"
References: <201009291911.o8TJBNCr042424@smtp-vbr13.xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.

--Boundary_(ID_Vg22WM+pY9etOjiNFwTx7A)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

Douglas:

Based on the logs from Hans' builds, I have prepared some updates.
Some of these might lead to undesired behavior of v4l on older or newer 
releases.
All of these should reduce the number of warnings or errors in the logs 
below.

Could you promote these changes to the git archive as well, if applicable ?

http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/rev/199ff5830453

Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
>
> Results of the daily build of v4l-dvb:
>
> date:        Wed Sep 29 19:00:10 CEST 2010
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   15164:1da5fed5c8b2
> git master:       3e6dce76d99b328716b43929b9195adfee1de00c
> git media-master: dace3857de7a16b83ae7d4e13c94de8e4b267d2a
> gcc version:      i686-linux-gcc (GCC) 4.4.3
> host hardware:    x86_64
> host os:          2.6.32.5
>
> linux-2.6.32.6-armv5: WARNINGS
> linux-2.6.33-armv5: OK
> linux-2.6.34-armv5: WARNINGS
> linux-2.6.35.3-armv5: WARNINGS
> linux-2.6.36-rc2-armv5: ERRORS
> linux-2.6.32.6-armv5-davinci: WARNINGS
> linux-2.6.33-armv5-davinci: WARNINGS
> linux-2.6.34-armv5-davinci: WARNINGS
> linux-2.6.35.3-armv5-davinci: WARNINGS
> linux-2.6.36-rc2-armv5-davinci: ERRORS
> linux-2.6.32.6-armv5-ixp: WARNINGS
> linux-2.6.33-armv5-ixp: WARNINGS
> linux-2.6.34-armv5-ixp: WARNINGS
> linux-2.6.35.3-armv5-ixp: WARNINGS
> linux-2.6.36-rc2-armv5-ixp: ERRORS
> linux-2.6.32.6-armv5-omap2: WARNINGS
> linux-2.6.33-armv5-omap2: WARNINGS
> linux-2.6.34-armv5-omap2: WARNINGS
> linux-2.6.35.3-armv5-omap2: WARNINGS
> linux-2.6.36-rc2-armv5-omap2: ERRORS
> linux-2.6.26.8-i686: WARNINGS
> linux-2.6.27.44-i686: WARNINGS
> linux-2.6.28.10-i686: WARNINGS
> linux-2.6.29.1-i686: WARNINGS
> linux-2.6.30.10-i686: WARNINGS
> linux-2.6.31.12-i686: WARNINGS
> linux-2.6.32.6-i686: WARNINGS
> linux-2.6.33-i686: WARNINGS
> linux-2.6.34-i686: WARNINGS
> linux-2.6.35.3-i686: WARNINGS
> linux-2.6.36-rc2-i686: ERRORS
> linux-2.6.32.6-m32r: WARNINGS
> linux-2.6.33-m32r: OK
> linux-2.6.34-m32r: WARNINGS
> linux-2.6.35.3-m32r: WARNINGS
> linux-2.6.36-rc2-m32r: ERRORS
> linux-2.6.32.6-mips: WARNINGS
> linux-2.6.33-mips: WARNINGS
> linux-2.6.34-mips: WARNINGS
> linux-2.6.35.3-mips: WARNINGS
> linux-2.6.36-rc2-mips: ERRORS
> linux-2.6.32.6-powerpc64: WARNINGS
> linux-2.6.33-powerpc64: WARNINGS
> linux-2.6.34-powerpc64: WARNINGS
> linux-2.6.35.3-powerpc64: WARNINGS
> linux-2.6.36-rc2-powerpc64: ERRORS
> linux-2.6.26.8-x86_64: WARNINGS
> linux-2.6.27.44-x86_64: WARNINGS
> linux-2.6.28.10-x86_64: WARNINGS
> linux-2.6.29.1-x86_64: WARNINGS
> linux-2.6.30.10-x86_64: WARNINGS
> linux-2.6.31.12-x86_64: WARNINGS
> linux-2.6.32.6-x86_64: WARNINGS
> linux-2.6.33-x86_64: WARNINGS
> linux-2.6.34-x86_64: WARNINGS
> linux-2.6.35.3-x86_64: WARNINGS
> linux-2.6.36-rc2-x86_64: ERRORS
> linux-git-Module.symvers: ERRORS
> linux-git-armv5: ERRORS
> linux-git-armv5-davinci: ERRORS
> linux-git-armv5-ixp: ERRORS
> linux-git-armv5-omap2: ERRORS
> linux-git-i686: ERRORS
> linux-git-m32r: ERRORS
> linux-git-mips: ERRORS
> linux-git-powerpc64: ERRORS
> linux-git-x86_64: ERRORS
> spec-git: OK
> sparse: ERRORS
>
> Detailed results are available here:
>
> http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
>
> Full logs are available here:
>
> http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2
>
> The V4L-DVB specification from this daily build is here:
>
> http://www.xs4all.nl/~hverkuil/spec/media.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--Boundary_(ID_Vg22WM+pY9etOjiNFwTx7A)
Content-type: text/x-vcard; charset=utf-8; name=jan-verisign.vcf
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=jan-verisign.vcf

begin:vcard
fn:Jan Hoogenraad
n:Hoogenraad;Jan
org:Hoogenraad Interface Services
adr;quoted-printable;dom:;;Postbus 2717;Utrecht;;-- =
	=0D=0A=
	Jan Hoogenraad=0D=0A=
	Hoogenraad Interface Services=0D=0A=
	Postbus 2717=0D=0A=
	3500 GS
email;internet:jan-verisign@hoogenraad.net
x-mozilla-html:FALSE
version:2.1
end:vcard


--Boundary_(ID_Vg22WM+pY9etOjiNFwTx7A)--
