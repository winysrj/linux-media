Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f174.google.com ([209.85.222.174]:47046 "EHLO
	mail-pz0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0BWNWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 08:22:54 -0500
Received: by pzk4 with SMTP id 4so547642pzk.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 05:22:53 -0800 (PST)
From: "Ahmad Issa" <issa.leb@gmail.com>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
References: <1a297b361002230336q7065170tc79ef22426ef5a8a@mail.gmail.com> <201002231406.36939.hftom@free.fr>
In-Reply-To: <201002231406.36939.hftom@free.fr>
Subject: RE: [linux-dvb] scan-s2 and dvb-apps
Date: Tue, 23 Feb 2010 16:16:10 +0300
Message-ID: <4b83d522.9513f30a.1ffc.29f2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think its better to use one application, so i prefer option (b)

-----Original Message-----
From: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org]
On Behalf Of Christophe Thommeret
Sent: Tuesday, February 23, 2010 4:07 PM
To: linux-media@vger.kernel.org; linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] scan-s2 and dvb-apps

Le mardi 23 février 2010 12:36:13, Manu Abraham a écrit :
> Hi All,
> 
> Recently, quite some people have been requesting for scan-s2 a simple
> scan application which has been hacked on top of the scan application
> as available in the dvb-apps tree, to be integrated/pulled in to the
> dvb-apps tree, after it's author moved on to other arenas.
> 
> http://www.mail-archive.com/vdr@linuxtv.org/msg11125.html
> 
> The idea initially was to have a cloned copy of scan as scan-s2.
> Now, on the other hand scan-s2 is much more like scan and similar
> functionality wise too.
> 
> Considering the aspects, do you think, that it is worthwhile to have
> 
> a) the scan-s2 application and the scan application as well integrated
> into the repository, such that they both live together
> 
> or
> 
> b) scan-s2 does things almost the same as scan2. scan can be replaced
> by scan-s2.
> 
> 
> What are your ideas/thoughts on this ?

I think S2 scanning should simply be added to scan.
My 2cents.

-- 
Christophe Thommeret



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

