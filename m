Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:36128 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbcCCRUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 12:20:01 -0500
Received: by mail-yw0-f175.google.com with SMTP id i131so10030556ywc.3
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 09:20:01 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Mar 2016 12:20:00 -0500
Message-ID: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
Subject: STK1160 - no video
From: Kevin Fitch <kfitch42@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently purchased a STK1160 based USB video capture device (Sabrent
USB-AVCPT). I have tested it on a windows computer and it works fine,
but not on any linux box I have tried.

lsusb reports:
Bus 002 Device 003: ID 05e1:0408 Syntek Semiconductor Co., Ltd STK1160
Video Capture Device

I am running Linux Mint with a 4.2.0 based kernel on AMD64:
$ uname -a
Linux home 4.2.0-30-generic #36~14.04.1-Ubuntu SMP Fri Feb 26 18:49:23
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

The exact results vary in different capture programs, but i always
seems to be something like a timeout waiting for the first frame.

I grabbed the driver source and added a few printk's to see what is
going on. The first time streaming is started it gets a single 8 byte
isochronous packet similar to:
80 0D 00 00 3D 61 0B 00
This is followed by a series of 4 byte packets (which the source code
refers to as "empty packets." These packets continue until streaming
is stopped.

00 01 00 00
00 02 00 00
...
00 3E 00 00
00 3F 00 00
00 00 00 00
00 01 00 00
...

The second time (and all subsequent times) streaming is started I seem
to get a single 8 byte packet similar to:
A0 0E 00 00 3D 61 0B 00

Each time streaming is started the second number appears to be incremented.

The is again followed by the same sequence of 4 byte packets as
mentioned before (all zeros, except the second byte increments
wrapping around after 3F).

I am at a bit of a loss as to where to continue debugging this. Any
suggestions will be appreciated.
