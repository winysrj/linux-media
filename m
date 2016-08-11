Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:38140 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbcHKMNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 08:13:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [RFC 3/4] Documentation: move dma-buf documentation to rst
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <CAB6B88B-C9E4-4213-A8A2-7BB39EC9B5F6@darmarit.de>
Date: Thu, 11 Aug 2016 14:12:03 +0200
Cc: "linux-media@vger.kernel.org Mailing List"
	<linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org Development"
	<dri-devel@lists.freedesktop.org>, linaro-mm-sig@lists.linaro.org,
	linux-doc@vger.kernel.org,
	"corbet@lwn.net Corbet" <corbet@lwn.net>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7000584B-8BE3-4948-8DB2-4088F3C88295@darmarit.de>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org> <1470912480-32304-4-git-send-email-sumit.semwal@linaro.org> <CAB6B88B-C9E4-4213-A8A2-7BB39EC9B5F6@darmarit.de>
To: Sumit Semwal <sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 11.08.2016 um 13:58 schrieb Markus Heiser <markus.heiser@darmarit.de>:
>> +.. note:: Until this stage, the buffer-exporter has the option to choose not to
>> +   actually allocate the backing storage for this buffer, but wait for the
>> +   first buffer-user to request use of buffer for allocation.
> 
> Use newlines ... which are markups in reST ;)
> 
> .. note:: 
> 
> Until this stage, the buffer-exporter has the option to choose not to
> actually allocate the backing storage for this buffer, but wait for the
> first buffer-user to request use of buffer for allocation.
> 

Sorry, my f... apple mail drops leading whitespaces ...

|.. note::
|
|   Until this stage, the buffer-exporter has the option to choose not to
|   actually allocate the backing storage for this buffer, but wait for the

>> +Kernel cpu access to a dma-buf buffer object
>> +============================================
>> +
>> +The motivation to allow cpu access from the kernel to a dma-buf object from the
>> +importers side are:
>> +
>> +* fallback operations, e.g. if the devices is connected to a usb bus and the
>> +  kernel needs to shuffle the data around first before sending it away.
>> +* full transparency for existing users on the importer side, i.e. userspace
>> +  should not notice the difference between a normal object from that subsystem
>> +  and an imported one backed by a dma-buf. This is really important for drm
>> +  opengl drivers that expect to still use all the existing upload/download
>> +  paths.
> 
> I is recommended to separate blocks (in this case the list item blocks) with
> a newline. E.g.
> 
> * first lorem
> ipsum
> 
> * second lorem
> ipsum
> 
> If you have only one-liners, it is OK to write
> 
> * first
> * second
> 

same here, leading whitespace are droped by the mail client.

|* first lorem
|  ipsum
|
|* second lorem
|  ipsum

Sorry for disorientation. For a snatch I forgot, that 
that Apple & MS have a mistaken idea of "plain text" ;)


-- Markus --








