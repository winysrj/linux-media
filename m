Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:53063 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDORa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 13:30:26 -0400
Message-ID: <534D6CAA.9020804@sca-uk.com>
Date: Tue, 15 Apr 2014 18:30:18 +0100
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534D6241.5060903@sca-uk.com> <534D68C2.6050902@xs4all.nl>
In-Reply-To: <534D68C2.6050902@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 15/04/14 18:13, Hans Verkuil wrote:
> Somewhat strange error message. Does 'dmesg' give you any useful info?
I get this:

image@image-H61M-DS2:~$ dmesg | grep -i cx23885
[   13.237914] cx23885: disagrees about version of symbol altera_init
[   13.237917] cx23885: Unknown symbol altera_init (err -22)
image@image-H61M-DS2:~$

There were altera_init issue in the dump I gave you earlier too.

Regards,

Steve.
