Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53457 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3IEVLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 17:11:12 -0400
Received: by mail-ob0-f181.google.com with SMTP id dn14so2587303obc.40
        for <linux-media@vger.kernel.org>; Thu, 05 Sep 2013 14:11:12 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 5 Sep 2013 23:10:52 +0200
Message-ID: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
Subject: RFC> multi-crop (was: Multiple Rectangle cropping)
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

 I am working porting a industrial camera driver to v4l. So far I have
been able to describe most of the old functionality with v4l
equivalents. The only thing that I am missing is multi cropping.

The sensor (both a cmosis and a ccd chips) supports skipping lines
from up to 8 regions. This increases the readout speed up to 50%,
which is critical for the application.

Unfortunately I have no way to describe multiple cropping areas in
v4l. I am thinking about creating a new API/extending and old one for
this.

Any suggestion before I start? Have you faced also this problem? How
did you solve it?

I am planning to go to the Edinburgh mini summit, maybe we could add
this to the agenda (if you consider that it is worth the time, of
course)

Thanks

-- 
Ricardo Ribalda
