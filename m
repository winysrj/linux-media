Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40664 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZJWCRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 22:17:10 -0400
Received: by ewy4 with SMTP id 4so1235509ewy.37
        for <linux-media@vger.kernel.org>; Thu, 22 Oct 2009 19:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3815ae099e769727cd4cb21abf338a18.squirrel@webmail.xs4all.nl>
References: <3815ae099e769727cd4cb21abf338a18.squirrel@webmail.xs4all.nl>
Date: Thu, 22 Oct 2009 22:17:13 -0400
Message-ID: <83bcf6340910221917y6915a49cg2cd99433735e1145@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> We did discuss this briefly during the v4l-dvb mini-summit and I know Mike
> Krufky knew what to do about this, but for the life of me I can't remember
> what it was. I should have made a note of it...
>
> Mike, can you refresh my memory?

You are correct Hans. Mike has some patches that begin to address this
for the ATSC products, standardizing some of the unit measurements.
Very clean, easy to review and merge.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
