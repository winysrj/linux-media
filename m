Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s16.bay0.hotmail.com ([65.54.190.91]:29046 "EHLO
	bay0-omc2-s16.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbaEGJh7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 May 2014 05:37:59 -0400
Message-ID: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: vb2_reqbufs() is not allowing more than VIDEO_MAX_FRAME
Date: Wed, 7 May 2014 15:07:59 +0530
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


I have a driver which is MUXING out data taking in multiple inputs.

It has been found in certain cases, at the minimum 40 buffers are required to be queued before it could MUX out anything.


Currently, VIDEO_MAX_FRAME is restricting the max size to 32. This can be over-ridden in driver queue_setup, but, it is making it mandatory to use always a particular count. So, it takes the independence from application to allocate any count> 32.


So, is it okay to revise this limit or introduce a new queue->depth variable which could be used in conjuction with VIDEO_MAX_FRAME to determine the num_buffers.


Regards,

Divneil 		 	   		  