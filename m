Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38950 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KJNYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 08:24:07 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Wed, 10 Nov 2010 18:53:40 +0530
Subject: mediabus enums
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC1A7C8C@dbde02.ent.ti.com>
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC1A7C79@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,
   Your media-bus enumerations capture the formats quite well. I needed the following for support on Davinci SOCs and liked to check with you if these are covered in some format in the list. 
1. Parallel RGB 666 (18 data lines+ 5 sync lines)
2. YUYV16 (16 lines) (16 data lines + 4 or 5 sync lines)


Thanks and Regards,
-Manju
