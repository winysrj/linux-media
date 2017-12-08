Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47817 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751492AbdLHSGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 13:06:18 -0500
Subject: Re: [PATCH] build: Fixed include compiler-gcc.h directly error
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1512755839-6716-1-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <dc7a2f94-fd60-628e-b968-ae86c52c40b3@anw.at>
Date: Fri, 8 Dec 2017 19:06:13 +0100
MIME-Version: 1.0
In-Reply-To: <1512755839-6716-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!

I am not sure why compiler-gcc.h is used from the kernel tree and not from
the installed kernel headers. So a better fix for this problem might be to
remove compiler-gcc.h from media_build/linux/Makefile. This is something
you will know better.

Please note that this doesn't fix all issues (pvrusb2-hdw.c doesn't compile
for Kernel 4.4.), but I am working on that currently.

BR,
   Jasmin
