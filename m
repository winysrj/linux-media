Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:65160 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3JBLNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 07:13:34 -0400
Received: by mail-we0-f179.google.com with SMTP id x55so747164wes.10
        for <linux-media@vger.kernel.org>; Wed, 02 Oct 2013 04:13:33 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Oct 2013 12:13:33 +0100
Message-ID: <CAK+ULv7aUPau3kowoJpJZqHc8EfEkCeHHcrTAR_dO-PaVkVYPw@mail.gmail.com>
Subject: V4l2 Mini-summit proposal: special API for SDI
From: Kieran Kunhya <kierank@obe.tv>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have been asked to propose a topic for the mini-summit regarding an
SDI (Serial Digital Interface) API of some sort. For those who are not
aware this is a professional interface used in broadcasting and CCTV.
The most serious issue is that many vendors provide Linux drivers with
V4L2 and ALSA - which is not acceptable for maintaining lipsync, let
alone maintaining the exact relationship between audio samples and
video that SDI provides.

Some other issues are mentioned here: https://wiki.videolan.org/SDI_API/
The wiki page has a very loose proposal for an API, though perhaps the
per-line idea is ambitious at this stage. Field or frame capture is
more realistic.

Regards,

Kieran Kunhya
