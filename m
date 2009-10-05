Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49454 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbZJEVNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 17:13:13 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Mon, 5 Oct 2009 16:12:30 -0500
Subject: RE: Mem2Mem V4L2 devices [RFC]
Message-ID: <A69FA2915331DC488A831521EAE36FE401553E95DC@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
	 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
	 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <1254773653.10214.31.camel@violet.int.mm-sol.com>
In-Reply-To: <1254773653.10214.31.camel@violet.int.mm-sol.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>>
>> Ivan,
>>
>> There is another use case where there are two Resizer hardware working on
>the same input frame and give two different output frames of different
>resolution. How do we handle this using the one video device approach you
>> just described here?
>
> what is the difference?
>
>- you can have only one resizer device driver which will hide that
>  they are actually 2 hardware resizers. just operations will be
>  faster ;).
>

In your implementation as mentioned above, there will be one queue for the OUTPUT buffer type and another queue for the CAPTURE buffer type right?
So if we have two Resizer outputs, then we would need two queues of the CAPTURE buffer type. When application calls QBUF, on the node, which queue will be used for the buffer? So this makes me believe we need to two capture nodes and one output node for this driver. 

>- they are two device drivers (nodes) with similar characteristics.
>
>in both cases input buffer can be the same.
>
>iivanov
>
>
>
>>
>> Murali
>

