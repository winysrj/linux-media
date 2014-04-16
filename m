Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:53215 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDPRLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 13:11:31 -0400
Message-ID: <534EB9BE.60102@sca-uk.com>
Date: Wed, 16 Apr 2014 18:11:26 +0100
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl>
In-Reply-To: <534BEA8A.2040604@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys,

On 14/04/14 15:02, Hans Verkuil wrote:

 > I'd appreciate it if you can test this with a proper video feed.

Ok, here is the first issue:

1) I have a 640x480 video feed which displays appropriately through 
stk1160, but only displays at 320x240 in ImpactVCBe.

In fact this is the same issue I had last year with:

echo cx23885 card=5 | sudo tee -a /etc/modules

Is your card giving you 640x480?

Thanks

Steve.
