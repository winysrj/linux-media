Return-path: <linux-media-owner@vger.kernel.org>
Received: from fisek2.ada.net.tr ([195.112.153.19]:40660 "HELO
	mail.fisek.com.tr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1761629AbZJNQFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 12:05:08 -0400
Date: Wed, 14 Oct 2009 18:57:33 +0300
From: Onur =?UTF-8?B?S8O8w6fDvGs=?= <onur@delipenguen.net>
To: linux-media@vger.kernel.org
Subject: Re: libv4l does not work!
Message-Id: <20091014185733.45a84258.onur@delipenguen.net>
In-Reply-To: <4AD5E813.2070406@gmail.com>
References: <4ACDF829.3010500@xfce.org>
	<37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>
	<4ACDFED9.30606@xfce.org>
	<829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>
	<4ACE2D5B.4080603@xfce.org>
	<829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
	<4ACF03BA.4070505@xfce.org>
	<829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>
	<4ACF714A.2090209@xfce.org>
	<829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
	<4AD5D5F2.9080102@xfce.org>
	<20091014093038.423f3304@pedra.chehab.org>
	<4AD5EEA0.2010709@xfce.org>
	<4AD5E813.2070406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wed, 14 Oct 2009 12:02:43 -0300
Guilherme Longo <grlongo.ireland@gmail.com> wrote:

> Do we need include any other header file than
> 
> libv4l2.h
> libv4lconvert.h
> 
> to get libv4l working?
> 
> I read Hans saying that:
> 
> Just replace open("dev/video0", ...) with v4l2_open
> ("dev/video0", ...), ioctl with v4l2_ioctl, etc. libv4l2 will then do
> conversion of any known (webcam) pixelformats to bgr24 or yuv420.
> 
> But I am getting undefined reference to 'v4l2_open' and 'v4l2_ioctl'.
> Can I get some help?

 You must also "link" your program with necessary libraries, for example

 gcc  code.c -lv4l2


-- 
 Onur Küçük                                      Knowledge speaks,
 <onur.--.-.delipenguen.net>                     but wisdom listens

