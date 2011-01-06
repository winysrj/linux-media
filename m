Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37218 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1AFDos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 22:44:48 -0500
Received: by fxm20 with SMTP id 20so15687667fxm.19
        for <linux-media@vger.kernel.org>; Wed, 05 Jan 2011 19:44:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=XSy2GU2+oBQXXWAgftsVZBkM5rxHGFGr3CGEm@mail.gmail.com>
References: <AANLkTi=XSy2GU2+oBQXXWAgftsVZBkM5rxHGFGr3CGEm@mail.gmail.com>
Date: Thu, 6 Jan 2011 00:44:46 -0300
Message-ID: <AANLkTimo4Oav1Duw6ZfeJEj8=nODJK70QRTRRiOZf9MY@mail.gmail.com>
Subject: Question about Night Mode
From: Roberto Rodriguez Alcala <rralcala@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi, i'm interested in implement the Night Mode for the ov7370 driver,
and it is done by modifyng 1 bit of the control register 11, but i'm
unable to find a V4l2 user Control ID for that (Ex:
V4L2-CID-NIGHT_MODE). I also think that the mentioned feature is quite
common in cameras so my question is:

Is there any control commonly used for that feature or it has to be a hack?

Thank you very much



--
Roberto Rodríguez Alcalá
