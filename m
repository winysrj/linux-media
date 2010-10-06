Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:50643 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab0JFUPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 16:15:55 -0400
MIME-Version: 1.0
Message-ID: <7d0dc6a7-f80e-4d2e-afa3-2c467efe68ba@default>
Date: Wed, 6 Oct 2010 13:14:59 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <ben@decadent.org.uk>
Cc: <mchehab@infradead.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH] vivi: Don't depend on FONTS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


| ----- Original Message -----
| From: ben@decadent.org.uk
| To: mchehab@infradead.org
| Cc: linux-media@vger.kernel.org, randy.dunlap@oracle.com
| Sent: Sunday, October 3, 2010 6:18:33 PM GMT -08:00 US/Canada Pacific
| Subject: [PATCH] vivi: Don't depend on FONTS
| 
| CONFIG_FONTS has nothing to do with whether find_font() is defined.
| 
| Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---

True.  I wonder how my patch mattered before, when I tested it.

Anyway:
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.
