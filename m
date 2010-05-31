Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.211.179]:55771 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0EaWWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 18:22:48 -0400
Received: by ywh9 with SMTP id 9so2991839ywh.17
        for <linux-media@vger.kernel.org>; Mon, 31 May 2010 15:22:47 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 May 2010 19:22:47 -0300
Message-ID: <AANLkTikHJfHDnSdX-TqHR9ZU4J6KRqS5vVgB9D0LynZC@mail.gmail.com>
Subject: tm6000 audio urb
From: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm having my first adventures on driver coding, trying to help audio
development of tm6000 based on Mauro's hints.

According to Mauro and coding comments, the audio URBs are already
being received by tm6000-video. The copy_packet function correctly
filters video packets (identified as cmd=1, extracted from header) and
the tm6000_msg_type array suggests that the cmd=2 would be the audio
packets. I logged all packets not being copied to video buffer and
realized that the only packets remaining have been identified as
cmd=4, which is supposedly type "pts".

For me it looks like either the cmd=4 type is audio, or the audio is
not really being received. Does this make sense?

Luis
