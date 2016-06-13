Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62273 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423567AbcFMStA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 14:49:00 -0400
Subject: Re: LinuxTv doesn't build anymore after upgrading Ubuntu to 3.13.0-88
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <575EE9D9.3030502@gmx.net> <575EF39A.4010609@xs4all.nl>
From: Andreas Matthies <a.matthies@gmx.net>
Message-ID: <575F0015.5030703@gmx.net>
Date: Mon, 13 Jun 2016 20:48:53 +0200
MIME-Version: 1.0
In-Reply-To: <575EF39A.4010609@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 13.06.2016 um 19:55 schrieb Hans Verkuil:
> On 06/13/2016 07:14 PM, Andreas Matthies wrote:
>> Hi.
>>
>> Seems that there's a problem in v4.6_i2c_mux.patch. After Ubuntu was
>> upgraded to 3.13.0-88 I tried to rebuild the tv drivers and get
>>
>> make[2]: Entering directory `/home/andreas/Downloads/media_build/linux'
>> Applying patches for kernel 3.13.0-88-generic
>> patch -s -f -N -p1 -i ../backports/api_version.patch
>> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
>> patch -s -f -N -p1 -i ../backports/debug.patch
>> patch -s -f -N -p1 -i ../backports/drx39xxj.patch
>> patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
>> 2 out of 23 hunks FAILED
>> make[2]: *** [apply_patches] Error 1
> Fixed. Thanks for reporting this.
>
That was fast! Thanks.
