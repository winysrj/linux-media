Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZIAIDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2009 04:03:54 -0400
Message-ID: <4A9CD5FD.4000301@redhat.com>
Date: Tue, 01 Sep 2009 10:06:21 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: [PATCH] libv4l: add NULL pointer check
References: <4A9A3EB0.8060304@freemail.hu>
In-Reply-To: <4A9A3EB0.8060304@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/30/2009 10:56 AM, Németh Márton wrote:
> From: Márton Németh<nm127@freemail.hu>
>
> Add NULL pointer check before the pointers are dereferenced.
>
> The patch was tested with v4l-test 0.19 [1] together with
> "Trust 610 LCD Powerc@m Zoom" in webcam mode.
>

http://linuxtv.org/hg/~hgoede/libv4l/rev/c51a90c0f62f

Regards,

hans
