Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37039 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab2CSJpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 05:45:40 -0400
Received: by ghrr11 with SMTP id r11so5233153ghr.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 02:45:39 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Mar 2012 10:45:39 +0100
Message-ID: <CAGa-wNOgmviyhOQbfmXP-O9272CyVSTJOgLK7S7MtRUuC8UcYw@mail.gmail.com>
Subject: build errors in radio subsystem
From: Claus Olesen <ceolesen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just got a kernel update that doesn't work for my PCTV 290e's so I
pulled and build the media_build tree and got the below errors which I
also got a week ago when I did the same after the previous kernel
update and I'm just reporting this without knowing how often errors
are fixed or for help if something is wrong at my end. The errors went
away after I inserted include of slab.h in those files.

/media_build/v4l/radio-isa.c:246:3: error: implicit declaration of
function 'kfree' [-Werror=implicit-function-declaration]
/media_build/v4l/radio-aztech.c:72:9: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-rtrack2.c:46:2: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-typhoon.c:76:9: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-terratec.c:57:2: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-aimslab.c:67:9: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-zoltrix.c:80:9: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-gemtek.c:183:9: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
media_build/v4l/radio-trust.c:57:9: error: implicit declaration of
function 'kzalloc' [-Werror=implicit-function-declaration]
