Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38285 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbaJaOiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 10:38:03 -0400
Received: by mail-pd0-f181.google.com with SMTP id y10so7302940pdj.26
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 07:38:02 -0700 (PDT)
Message-ID: <54539EC6.8090001@gmail.com>
Date: Fri, 31 Oct 2014 23:37:58 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/7] v4l-utils/libdvbv5: add support for ISDB-S scanning
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com> <1414323983-15996-4-git-send-email-tskd08@gmail.com> <20141027124650.522d394b.m.chehab@samsung.com>
In-Reply-To: <20141027124650.522d394b.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014年10月27日 23:46, Mauro Carvalho Chehab wrote:

> Always right circular polarization? I guess I read something at the specs
> sometime ago about left polarization too. Not sure if this is actually used.

Currently all transponders of ISDB-S use right polarization.
but I modifed this part and removed POLARIZATION prop from ISDB-S in v3.
--
Akihiro
