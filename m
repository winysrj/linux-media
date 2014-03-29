Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:64469 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaC2NoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 09:44:16 -0400
Received: by mail-yh0-f44.google.com with SMTP id f10so6073289yha.3
        for <linux-media@vger.kernel.org>; Sat, 29 Mar 2014 06:44:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5336BA70.2080807@podiumbv.nl>
References: <5336B87A.2010402@podiumbv.nl>
	<5336BA70.2080807@podiumbv.nl>
Date: Sat, 29 Mar 2014 09:44:15 -0400
Message-ID: <CALzAhNVHYzBDbMSM9PFwswE3rQYhrX1e9MbAVjSYaUJ=-CcsfA@mail.gmail.com>
Subject: Re: FireDTV / w_scan / no data from NIT(actual)
From: Steven Toth <stoth@kernellabs.com>
To: mailinglist@podiumbv.nl
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Only is goes already wrong with the init scan.... I only get: "Info: no data
> from NIT(actual)"

I suspect either their isn't a NIT(actual) table on your frequency, or
the tool isn't waiting long enough for the NIT table to arrive.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
