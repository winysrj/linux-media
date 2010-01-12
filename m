Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59094 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0ALVoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 16:44:46 -0500
Received: by fxm25 with SMTP id 25so171960fxm.21
        for <linux-media@vger.kernel.org>; Tue, 12 Jan 2010 13:44:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4CE912.1000906@von-eitzen.de>
References: <4B4CE912.1000906@von-eitzen.de>
Date: Tue, 12 Jan 2010 16:44:44 -0500
Message-ID: <829197381001121344l3ad94bdajdd4eb0345b895f2b@mail.gmail.com>
Subject: Re: VL4-DVB compilation issue not covered by Daily Automated
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hagen von Eitzen <hagen@von-eitzen.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 12, 2010 at 4:26 PM, Hagen von Eitzen <hagen@von-eitzen.de> wrote:
>
> Dear all,
> as suggested by http://www.linuxtv.org/wiki/index.php/Bug_Report I report several warnings and errors not yet covered in latest http://www.xs4all.nl/~hverkuil/logs/Monday.log I get when compiling.
> (The purpose of my experiments was trying to find out something about "0ccd:00a5 TerraTec Electronic GmbH")
>
> Regards
> Hagen

This is an Ubuntu-specific issue (they improperly packaged their
kernel headers), which will not be covered by the daily build system
(which exercises various kernels but not across different Linux
distribution versions).

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
