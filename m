Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:46967 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3F0S6e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 14:58:34 -0400
Received: by mail-qc0-f176.google.com with SMTP id z10so771479qcx.35
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 11:58:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
Date: Thu, 27 Jun 2013 14:58:34 -0400
Message-ID: <CALzAhNW3A-EZ0-bXeno2-Zd-bxOM_D=TU7F+cN63CwmUTA7JDg@mail.gmail.com>
Subject: Re: lgdt3304
From: Steven Toth <stoth@kernellabs.com>
To: Carl-Fredrik Sundstrom <cf@blueflowamericas.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I get so far that I can load a basic driver by modifying the existing
> saa716x driver, I can detect the TDA18271HD/C2, but I fail to detect the
> LGDT3304 when attaching it using the 3305 driver.

A GPIO holding the 3304 in reset?

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
