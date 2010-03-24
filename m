Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:19206 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0CXQ7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 12:59:11 -0400
Message-ID: <4BAA449F.1060506@oracle.com>
Date: Wed, 24 Mar 2010 09:58:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	shu.lin@conexant.com, hiep.huynh@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mmotm 2010-03-23-15-34 uploaded (staging vs. media)
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org>
In-Reply-To: <201003232301.o2NN1bms031050@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/10 15:34, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-03-23-15-34 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git


drivers/staging/cx25821/cx25821-video.c:89:struct cx25821_fmt *format_by_fourcc(unsigned int fourcc)
(not static)

conflicts with (has the same non-static name as)

drivers/media/common/saa7146_video.c:87:struct saa7146_format* format_by_fourcc(struct saa7146_dev *dev, int fourcc)


so when both of these drivers are built into the kernel image:

(.text+0x6360): multiple definition of `format_by_fourcc'


-- 
~Randy
