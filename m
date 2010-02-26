Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50697 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936066Ab0BZNL7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 08:11:59 -0500
Received: by bwz1 with SMTP id 1so51273bwz.1
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 05:11:57 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 26 Feb 2010 08:11:56 -0500
Message-ID: <55a3e0ce1002260511s6351a6e6k548f329f1dc7b698@mail.gmail.com>
Subject: support for device node for sub devices
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

I see that you have added support for sub device device nodes in your
media controller development tree. This is an important feature for
SoC devices since this will allow application to configure the sub
device nodes like that on VPFE/VPBE of a DMxxx device. Shouldn't we
add this feature right away perhaps in 2.6.35 so that drivers can make
use of it?
-- 
Murali Karicheri
