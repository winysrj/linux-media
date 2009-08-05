Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:11605 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934356AbZHEOOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 10:14:38 -0400
Received: by an-out-0708.google.com with SMTP id d40so125473and.1
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 07:14:37 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 22:14:37 +0800
Message-ID: <15ed362e0908050714y61696f9gf794a907e85ed801@mail.gmail.com>
Subject: lgs8gxx: 64bit division
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

  Someone complains that he cannot compile my lgs8gxx.c on gcc3,
unknown kernel version.  Compilation
error at line 249 about the 64-bit division. I have no compilation
error on my x86_64 system, gcc4,
linux-2.6.28 kernel. Should the 64-bit division code be changed?

  There is also it 64bit / 32bit division via do_div(), is it correct?

David
