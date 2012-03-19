Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab2CSWMo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:12:44 -0400
Message-ID: <4F67AF4F.4050407@redhat.com>
Date: Mon, 19 Mar 2012 19:12:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH RESEND] usb: gadget/uvc: Remove non-required locking from
 'uvc_queue_next_buffer' routine
References: <d5dbc7befb35abdce18d77f918954137a2be2f26.1331638300.git.bhupesh.sharma@st.com> <11788268.pQ7t4NVJy6@avalon> <D5ECB3C7A6F99444980976A8C6D896384FA2BA2E91@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA2BA2E91@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-03-2012 00:58, Bhupesh SHARMA escreveu:
> Hi Laurent,
> 
>> -----Original Message-----
>> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
>> Sent: Thursday, March 15, 2012 6:17 AM
>> To: Bhupesh SHARMA
>> Cc: linux-usb@vger.kernel.org; linux-media@vger.kernel.org; spear-devel
>> Subject: Re: [PATCH RESEND] usb: gadget/uvc: Remove non-required
>> locking from 'uvc_queue_next_buffer' routine
>>
>> Hi Bhupesh,
>>
>> Thank you for the patch.
> 
...
>> This should probably go in through the USB tree. 
...
For sure, as this stuff doesn't belong to drivers/media ;)

Regards,
Mauro
