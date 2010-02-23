Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.orange.fr ([80.12.242.47]:55118 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab0BWNGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 08:06:17 -0500
From: Christophe Thommeret <hftom@free.fr>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] scan-s2 and dvb-apps
Date: Tue, 23 Feb 2010 14:06:36 +0100
References: <1a297b361002230336q7065170tc79ef22426ef5a8a@mail.gmail.com>
In-Reply-To: <1a297b361002230336q7065170tc79ef22426ef5a8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002231406.36939.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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


