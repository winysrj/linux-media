Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbZLDFLa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 00:11:30 -0500
Date: Thu, 3 Dec 2009 21:11:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: drivers/media/video/gspca/ov534.c warning
Message-Id: <20091203211100.9c7ad512.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/gspca/ov534.c: In function 'setsharpness_96':
drivers/media/video/gspca/ov534.c:1539: warning: comparison is always false due to limited range of data type

this code can't ever have worked.
