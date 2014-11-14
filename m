Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43068 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161184AbaKNT31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 14:29:27 -0500
Received: by mail-pd0-f174.google.com with SMTP id p10so17196542pdj.19
        for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 11:29:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
References: <m3lhneez9h.fsf@t19.piap.pl>
	<CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
Date: Fri, 14 Nov 2014 23:29:26 +0400
Message-ID: <CANZNk80MyeObaFWPEskbBYh5=6WLBYvMMXFEga7jNtTPYBG44w@mail.gmail.com>
Subject: Re: SOLO6x10: fix a race in IRQ handler.
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: =?ISO-8859-2?Q?Krzysztof_Ha=B3asa?= <khalasa@piap.pl>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also while you're at it, and if this really makes sense, you could
merge these two writes (unrecognized bits, then recognized bits) to
one write act.
-- 
Andrey Utkin
