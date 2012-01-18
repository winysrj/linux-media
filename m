Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57077 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2ARE4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 23:56:06 -0500
Received: by iagf6 with SMTP id f6so5366886iag.19
        for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 20:56:06 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Denilson_Figueiredo_de_S=C3=A1?= <denilsonsa@gmail.com>
Date: Wed, 18 Jan 2012 02:55:45 -0200
Message-ID: <CACGt9y=6nB-F+P08L-soBDVRe5K1Lry-jg-tdM21agjeYJt2fg@mail.gmail.com>
Subject: Compile error at media_build
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've tried to compile media_build in a 2.6.38 kernel. I got a compile
error related to implicit declaration of 'kzalloc'.

The solution was to add #include <linux/slab.h> to this file:
media_build/v4l/as3645a.c


-- 
Denilson Figueiredo de Sá
Belo Horizonte - Brasil
