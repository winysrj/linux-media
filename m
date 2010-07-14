Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41206 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0GNDCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 23:02:15 -0400
Received: by gwj18 with SMTP id 18so3150138gwj.19
        for <linux-media@vger.kernel.org>; Tue, 13 Jul 2010 20:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik5_v0Siy4K6rA0gsLxmA1XmoJAlVv3Dd1gu5hb@mail.gmail.com>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele> <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele> <AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele> <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
	<20100710113616.1ed63ebc@tele> <AANLkTikrKBpRSI6wVdMO3tSYPhm1CECFGeNiyJdzTa03@mail.gmail.com>
	<20100711155008.1f8f583f@tele> <AANLkTinnNhJ-DoFWfU8U5NuTj_p48SefYzWWAxZqiUb-@mail.gmail.com>
	<20100712101802.08527e82@tele> <AANLkTinUHyTHt78ihMHy8dzz0kfPvUMBXKreRmuM-cYW@mail.gmail.com>
	<20100712132100.1b4072b9@tele> <AANLkTimku962Cm_7glThtq3X3jZiwmHSWOYzc2d3WLBl@mail.gmail.com>
	<20100713211345.43caeabb@tele> <AANLkTik5_v0Siy4K6rA0gsLxmA1XmoJAlVv3Dd1gu5hb@mail.gmail.com>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Tue, 13 Jul 2010 23:01:55 -0400
Message-ID: <AANLkTileCxtocP4Y222C2KInlHC5IA_U0Oyy7JAXmwGc@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 13, 2010 at 7:59 PM, Kyle Baker <kyleabaker@gmail.com> wrote:
> On a different note, I've noticed that there is a bug either with
> Cheese or with the camera drivers after recording video. The problem
> is that, after I record a video in Cheese, the recording stops and the
> video is saved, but the record button is now disabled until I reopen
> the application.

I've tested this on my Ubuntu 10.04 32-bit laptop with both GSPCA
2.7.0 and GSPCA 2.9.52. The results match, Cheese 2.30.1 works as
intended. However, I'm using the same version of Cheese on my Ubuntu
10.10 64-bit computer and results are different. I'll keep an eye on
this issue and if it doesn't clear up by time of Ubuntu 10.10 release
then I'll look back into it.

FYI, there is a warning message in the "make" process that I wanted to
bring your attention to. Its not causing problems, but maybe it can be
removed?
.../gspca-2.9.52/build/jpeg.h:152: warning: ‘jpeg_set_qual’ defined but not used

Cheers.

-- 
Kyle Baker
