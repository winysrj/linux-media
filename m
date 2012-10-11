Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63504 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2JKKkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 06:40:45 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so2078674wib.1
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2012 03:40:44 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 11 Oct 2012 12:40:03 +0200
Message-ID: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com>
Subject: Multiple Rectangle cropping
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello List

I want to port an old driver for an fpga based camera to the new media
infrastructure.

By reading the doc. I think it has almost all the capabilities needed.
The only one I am missing is the habilty to select multiple rectangles
from the sensor. ie: I have a 100x50 sensor and I want a 100x20 image
with the pixels from 0,0->100,10 and then 0,40->100,50

Any suggestion about how to implement this with the media api?

Regards.

-- 
Ricardo Ribalda
