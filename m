Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36227 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2KDLvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 06:51:01 -0500
Received: by mail-bk0-f46.google.com with SMTP id jk13so1692656bkc.19
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2012 03:51:00 -0800 (PST)
Message-ID: <509656A5.6000902@googlemail.com>
Date: Sun, 04 Nov 2012 12:51:01 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
CC: Wojciech Myrda <vojcek@tlen.pl>, linux-media@vger.kernel.org
Subject: Re: [segfault] running ir-keytable with v4l-utils 0.8.9
References: <507B1879.9020100@tlen.pl> <508BC4F9.303@googlemail.com>
In-Reply-To: <508BC4F9.303@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 10/27/12 1:26 PM, Gregor Jasny wrote:
> I looked at the crash and it seems that the rc_dev structure is not
> initialized when a device name is set on the command line. Could you
> please take a look?

I filed this as a Fedora bug report so that it does not get lost:
https://bugzilla.redhat.com/show_bug.cgi?id=872927

Thanks,
Gregor
