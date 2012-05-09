Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35927 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2EIGql (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 02:46:41 -0400
Message-ID: <4FAA12C7.8020307@gmail.com>
Date: Wed, 09 May 2012 12:16:31 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com> <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com> <4FA7DE61.7000705@gmail.com> <4675433.ieio0xx0Y0@avalon> <4FA9005F.6020901@gmail.com>
In-Reply-To: <4FA9005F.6020901@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070200060801070106080701"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070200060801070106080701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Tomasz, Laurent,

I have printed some logs during the dmabuf export and attach for the SGT 
issue below. Please find it in the attachment. I hope it will be useful.

Regards,
Subash

On 05/08/2012 04:45 PM, Subash Patel wrote:
> Hi Laurent,
>
> On 05/08/2012 02:44 PM, Laurent Pinchart wrote:
>> Hi Subash,
>>
>> On Monday 07 May 2012 20:08:25 Subash Patel wrote:
>>> Hello Thomasz, Laurent,
>>>
>>> I found an issue in the function vb2_dc_pages_to_sgt() below. I saw that
>>> during the attach, the size of the SGT and size requested mis-matched
>>> (by atleast 8k bytes). Hence I made a small correction to the code as
>>> below. I could then attach the importer properly.
>>
>> Thank you for the report.
>>
>> Could you print the content of the sglist (number of chunks and size
>> of each
>> chunk) before and after your modifications, as well as the values of
>> n_pages,
>> offset and size ?
> I will put back all the printk's and generate this. As of now, my setup
> has changed and will do this when I get sometime.
>>
>>> On 04/20/2012 08:15 PM, Tomasz Stanislawski wrote:
>>
>> [snip]
>>
>>>> +static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
>>>> + unsigned int n_pages, unsigned long offset, unsigned long size)
>>>> +{
>>>> + struct sg_table *sgt;
>>>> + unsigned int chunks;
>>>> + unsigned int i;
>>>> + unsigned int cur_page;
>>>> + int ret;
>>>> + struct scatterlist *s;
>>>> +
>>>> + sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
>>>> + if (!sgt)
>>>> + return ERR_PTR(-ENOMEM);
>>>> +
>>>> + /* compute number of chunks */
>>>> + chunks = 1;
>>>> + for (i = 1; i< n_pages; ++i)
>>>> + if (pages[i] != pages[i - 1] + 1)
>>>> + ++chunks;
>>>> +
>>>> + ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
>>>> + if (ret) {
>>>> + kfree(sgt);
>>>> + return ERR_PTR(-ENOMEM);
>>>> + }
>>>> +
>>>> + /* merging chunks and putting them into the scatterlist */
>>>> + cur_page = 0;
>>>> + for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
>>>> + unsigned long chunk_size;
>>>> + unsigned int j;
>>>
>>> size = PAGE_SIZE;
>>>
>>>> +
>>>> + for (j = cur_page + 1; j< n_pages; ++j)
>>>
>>> for (j = cur_page + 1; j< n_pages; ++j) {
>>>
>>>> + if (pages[j] != pages[j - 1] + 1)
>>>> + break;
>>>
>>> size += PAGE
>>> }
>>>
>>>> +
>>>> + chunk_size = ((j - cur_page)<< PAGE_SHIFT) - offset;
>>>> + sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
>>>
>>> [DELETE] size -= chunk_size;
>>>
>>>> + offset = 0;
>>>> + cur_page = j;
>>>> + }
>>>> +
>>>> + return sgt;
>>>> +}
>>
> Regards,
> Subash

--------------070200060801070106080701
Content-Type: text/plain; charset=UTF-8;
 name="vb2_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vb2_log"

[  178.545000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.545000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.550000] vb2_dc_pages_to_sgt():84 offset=0
[  178.555000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  178.560000] vb2_dc_pages_to_sgt():89 size=4294836224
[  178.565000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.570000] vb2_dc_pages_to_sgt():83 cur_page=32
[  178.575000] vb2_dc_pages_to_sgt():84 offset=0
[  178.580000] vb2_dc_pages_to_sgt():86 chunk_size=262144
[  178.585000] vb2_dc_pages_to_sgt():89 size=4294574080
[  178.590000] vb2_dc_pages_to_sgt() sgt->orig_nents=1
[  178.595000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.600000] vb2_dc_pages_to_sgt():84 offset=0
[  178.605000] vb2_dc_pages_to_sgt():86 chunk_size=8192
[  178.610000] vb2_dc_pages_to_sgt():89 size=4294959104
[  178.625000] vb2_dc_pages_to_sgt() sgt->orig_nents=1
[  178.625000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.630000] vb2_dc_pages_to_sgt():84 offset=0
[  178.635000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  178.640000] vb2_dc_pages_to_sgt():89 size=4294836224
[  178.645000] vb2_dc_pages_to_sgt() sgt->orig_nents=1
[  178.650000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.655000] vb2_dc_pages_to_sgt():84 offset=0
[  178.660000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  178.665000] vb2_dc_pages_to_sgt():89 size=4294836224
[  178.670000] vb2_dc_mmap: mapped dma addr 0x20060000 at 0xb6e01000, size 131072
[  178.670000] vb2_dc_mmap: mapped dma addr 0x20080000 at 0xb6de1000, size 131072
[  178.680000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.685000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.690000] vb2_dc_pages_to_sgt():84 offset=0
[  178.695000] vb2_dc_pages_to_sgt():86 chunk_size=4096
[  178.700000] vb2_dc_pages_to_sgt():89 size=4294963200
[  178.705000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.710000] vb2_dc_pages_to_sgt():83 cur_page=1
[  178.715000] vb2_dc_pages_to_sgt():84 offset=0
[  178.715000] vb2_dc_pages_to_sgt():86 chunk_size=8192
[  178.720000] vb2_dc_pages_to_sgt():89 size=4294955008
[  178.725000] vb2_dc_pages_to_sgt() sgt->orig_nents=1
[  178.730000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.735000] vb2_dc_pages_to_sgt():84 offset=0
[  178.740000] vb2_dc_pages_to_sgt():86 chunk_size=8192
[  178.745000] vb2_dc_pages_to_sgt():89 size=4294959104
[  178.750000] vb2_dc_pages_to_sgt() sgt->orig_nents=1
[  178.755000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.760000] vb2_dc_pages_to_sgt():84 offset=0
[  178.765000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  178.770000] vb2_dc_pages_to_sgt():89 size=4294836224
[  178.780000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.780000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.785000] vb2_dc_pages_to_sgt():84 offset=0
[  178.790000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  178.795000] vb2_dc_pages_to_sgt():89 size=4294901760
[  178.800000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.805000] vb2_dc_pages_to_sgt():83 cur_page=16
[  178.810000] vb2_dc_pages_to_sgt():84 offset=0
[  178.815000] vb2_dc_pages_to_sgt():86 chunk_size=393216
[  178.820000] vb2_dc_pages_to_sgt():89 size=4294508544
[  178.825000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  178.830000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.835000] vb2_dc_pages_to_sgt():84 offset=0
[  178.840000] vb2_dc_pages_to_sgt():86 chunk_size=32768
[  178.845000] vb2_dc_pages_to_sgt():89 size=4294934528
[  178.850000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  178.855000] vb2_dc_pages_to_sgt():83 cur_page=8
[  178.855000] vb2_dc_pages_to_sgt():84 offset=0
[  178.860000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  178.865000] vb2_dc_pages_to_sgt():89 size=4294868992
[  178.870000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  178.875000] vb2_dc_pages_to_sgt():83 cur_page=24
[  178.880000] vb2_dc_pages_to_sgt():84 offset=0
[  178.885000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  178.890000] vb2_dc_pages_to_sgt():89 size=4294737920
[  178.895000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.900000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.905000] vb2_dc_pages_to_sgt():84 offset=0
[  178.910000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  178.915000] vb2_dc_pages_to_sgt():89 size=4294901760
[  178.920000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  178.925000] vb2_dc_pages_to_sgt():83 cur_page=16
[  178.930000] vb2_dc_pages_to_sgt():84 offset=0
[  178.935000] vb2_dc_pages_to_sgt():86 chunk_size=393216
[  178.940000] vb2_dc_pages_to_sgt():89 size=4294508544
[  178.945000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  178.950000] vb2_dc_pages_to_sgt():83 cur_page=0
[  178.955000] vb2_dc_pages_to_sgt():84 offset=0
[  178.960000] vb2_dc_pages_to_sgt():86 chunk_size=32768
[  178.965000] vb2_dc_pages_to_sgt():89 size=4294934528
[  178.970000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  178.975000] vb2_dc_pages_to_sgt():83 cur_page=8
[  178.975000] vb2_dc_pages_to_sgt():84 offset=0
[  178.980000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  178.985000] vb2_dc_pages_to_sgt():89 size=4294868992
[  178.990000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  178.995000] vb2_dc_pages_to_sgt():83 cur_page=24
[  179.000000] vb2_dc_pages_to_sgt():84 offset=0
[  179.005000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.010000] vb2_dc_pages_to_sgt():89 size=4294737920
[  179.015000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.020000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.025000] vb2_dc_pages_to_sgt():84 offset=0
[  179.030000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.035000] vb2_dc_pages_to_sgt():89 size=4294901760
[  179.040000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.045000] vb2_dc_pages_to_sgt():83 cur_page=16
[  179.050000] vb2_dc_pages_to_sgt():84 offset=0
[  179.055000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.060000] vb2_dc_pages_to_sgt():89 size=4294770688
[  179.065000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.070000] vb2_dc_pages_to_sgt():83 cur_page=48
[  179.075000] vb2_dc_pages_to_sgt():84 offset=0
[  179.080000] vb2_dc_pages_to_sgt():86 chunk_size=262144
[  179.085000] vb2_dc_pages_to_sgt():89 size=4294508544
[  179.090000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.095000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.100000] vb2_dc_pages_to_sgt():84 offset=0
[  179.100000] vb2_dc_pages_to_sgt():86 chunk_size=32768
[  179.105000] vb2_dc_pages_to_sgt():89 size=4294934528
[  179.110000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.115000] vb2_dc_pages_to_sgt():83 cur_page=8
[  179.120000] vb2_dc_pages_to_sgt():84 offset=0
[  179.125000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.130000] vb2_dc_pages_to_sgt():89 size=4294868992
[  179.135000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.140000] vb2_dc_pages_to_sgt():83 cur_page=24
[  179.145000] vb2_dc_pages_to_sgt():84 offset=0
[  179.150000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.155000] vb2_dc_pages_to_sgt():89 size=4294737920
[  179.160000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  179.165000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.170000] vb2_dc_pages_to_sgt():84 offset=0
[  179.175000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.180000] vb2_dc_pages_to_sgt():89 size=4294901760
[  179.185000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  179.190000] vb2_dc_pages_to_sgt():83 cur_page=16
[  179.195000] vb2_dc_pages_to_sgt():84 offset=0
[  179.200000] vb2_dc_pages_to_sgt():86 chunk_size=393216
[  179.205000] vb2_dc_pages_to_sgt():89 size=4294508544
[  179.210000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.215000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.220000] vb2_dc_pages_to_sgt():84 offset=0
[  179.220000] vb2_dc_pages_to_sgt():86 chunk_size=32768
[  179.225000] vb2_dc_pages_to_sgt():89 size=4294934528
[  179.230000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.235000] vb2_dc_pages_to_sgt():83 cur_page=8
[  179.240000] vb2_dc_pages_to_sgt():84 offset=0
[  179.245000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.250000] vb2_dc_pages_to_sgt():89 size=4294868992
[  179.255000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.260000] vb2_dc_pages_to_sgt():83 cur_page=24
[  179.265000] vb2_dc_pages_to_sgt():84 offset=0
[  179.270000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.275000] vb2_dc_pages_to_sgt():89 size=4294737920
[  179.280000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.285000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.290000] vb2_dc_pages_to_sgt():84 offset=0
[  179.295000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.300000] vb2_dc_pages_to_sgt():89 size=4294901760
[  179.305000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.310000] vb2_dc_pages_to_sgt():83 cur_page=16
[  179.315000] vb2_dc_pages_to_sgt():84 offset=0
[  179.320000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.325000] vb2_dc_pages_to_sgt():89 size=4294770688
[  179.330000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.335000] vb2_dc_pages_to_sgt():83 cur_page=48
[  179.340000] vb2_dc_pages_to_sgt():84 offset=0
[  179.340000] vb2_dc_pages_to_sgt():86 chunk_size=262144
[  179.350000] vb2_dc_pages_to_sgt():89 size=4294508544
[  179.355000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.355000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.360000] vb2_dc_pages_to_sgt():84 offset=0
[  179.365000] vb2_dc_pages_to_sgt():86 chunk_size=32768
[  179.370000] vb2_dc_pages_to_sgt():89 size=4294934528
[  179.375000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.380000] vb2_dc_pages_to_sgt():83 cur_page=8
[  179.385000] vb2_dc_pages_to_sgt():84 offset=0
[  179.390000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.395000] vb2_dc_pages_to_sgt():89 size=4294868992
[  179.400000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.405000] vb2_dc_pages_to_sgt():83 cur_page=24
[  179.410000] vb2_dc_pages_to_sgt():84 offset=0
[  179.415000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.420000] vb2_dc_pages_to_sgt():89 size=4294737920
[  179.425000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  179.430000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.435000] vb2_dc_pages_to_sgt():84 offset=0
[  179.440000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.445000] vb2_dc_pages_to_sgt():89 size=4294901760
[  179.450000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  179.455000] vb2_dc_pages_to_sgt():83 cur_page=16
[  179.460000] vb2_dc_pages_to_sgt():84 offset=0
[  179.460000] vb2_dc_pages_to_sgt():86 chunk_size=393216
[  179.470000] vb2_dc_pages_to_sgt():89 size=4294508544
[  179.475000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.475000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.480000] vb2_dc_pages_to_sgt():84 offset=0
[  179.485000] vb2_dc_pages_to_sgt():86 chunk_size=32768
[  179.490000] vb2_dc_pages_to_sgt():89 size=4294934528
[  179.495000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.500000] vb2_dc_pages_to_sgt():83 cur_page=8
[  179.505000] vb2_dc_pages_to_sgt():84 offset=0
[  179.510000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.515000] vb2_dc_pages_to_sgt():89 size=4294868992
[  179.520000] vb2_dc_pages_to_sgt() sgt->orig_nents=3
[  179.525000] vb2_dc_pages_to_sgt():83 cur_page=24
[  179.530000] vb2_dc_pages_to_sgt():84 offset=0
[  179.535000] vb2_dc_pages_to_sgt():86 chunk_size=131072
[  179.540000] vb2_dc_pages_to_sgt():89 size=4294737920
[  179.545000] mmc0: Too large timeout requested for CMD25!
[  179.545000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  179.550000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.555000] mmc0: Too large timeout requested for CMD25!
[  179.555000] vb2_dc_pages_to_sgt():84 offset=0
[  179.560000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.565000] mmc0: Too large timeout requested for CMD25!
[  179.565000] vb2_dc_pages_to_sgt():89 size=4294901760
[  179.570000] vb2_dc_pages_to_sgt() sgt->orig_nents=2
[  179.575000] vb2_dc_pages_to_sgt():83 cur_page=16
[  179.580000] vb2_dc_pages_to_sgt():84 offset=0
[  179.580000] vb2_dc_pages_to_sgt():86 chunk_size=262144
[  179.590000] vb2_dc_pages_to_sgt():89 size=4294639616
[  179.595000] vb2_dc_mmap: mapped dma addr 0x40000000 at 0xb6d71000, size 458752
[  179.595000] vb2_dc_mmap: mapped dma addr 0x20100000 at 0xb6d39000, size 229376
[  179.595000] vb2_dc_mmap: mapped dma addr 0x40080000 at 0xb6cc9000, size 458752
[  179.595000] vb2_dc_mmap: mapped dma addr 0x20140000 at 0xb6c91000, size 229376
[  179.595000] vb2_dc_mmap: mapped dma addr 0x40100000 at 0xb6c21000, size 458752
[  179.595000] vb2_dc_mmap: mapped dma addr 0x20180000 at 0xb6be9000, size 229376
[  179.595000] vb2_dc_mmap: mapped dma addr 0x40180000 at 0xb6b79000, size 458752
[  179.595000] vb2_dc_mmap: mapped dma addr 0x201c0000 at 0xb6b41000, size 229376
[  179.595000] vb2_dc_mmap: mapped dma addr 0x40200000 at 0xb6ad1000, size 458752
[  179.595000] vb2_dc_mmap: mapped dma addr 0x20200000 at 0xb6a99000, size 229376
[  179.600000] vb2_dc_mmap: mapped dma addr 0x40280000 at 0xb6a29000, size 458752
[  179.600000] vb2_dc_mmap: mapped dma addr 0x20240000 at 0xb69f1000, size 229376
[  179.600000] vb2_dc_pages_to_sgt() sgt->orig_nents=4
[  179.605000] vb2_dc_pages_to_sgt():83 cur_page=0
[  179.610000] vb2_dc_pages_to_sgt():84 offset=0
[  179.615000] vb2_dc_pages_to_sgt():86 chunk_size=8192
[  179.620000] vb2_dc_pages_to_sgt():89 size=4294959104
[  179.625000] vb2_dc_pages_to_sgt() sgt->orig_nents=4
[  179.630000] vb2_dc_pages_to_sgt():83 cur_page=2
[  179.635000] vb2_dc_pages_to_sgt():84 offset=0
[  179.635000] vb2_dc_pages_to_sgt():86 chunk_size=16384
[  179.640000] vb2_dc_pages_to_sgt():89 size=4294942720
[  179.645000] vb2_dc_pages_to_sgt() sgt->orig_nents=4
[  179.650000] vb2_dc_pages_to_sgt():83 cur_page=6
[  179.655000] vb2_dc_pages_to_sgt():84 offset=0
[  179.660000] vb2_dc_pages_to_sgt():86 chunk_size=65536
[  179.665000] vb2_dc_pages_to_sgt():89 size=4294877184
[  179.670000] vb2_dc_pages_to_sgt() sgt->orig_nents=4
[  179.675000] vb2_dc_pages_to_sgt():83 cur_page=22
[  179.680000] vb2_dc_pages_to_sgt():84 offset=0
[  179.685000] vb2_dc_pages_to_sgt():86 chunk_size=524288
[  179.690000] vb2_dc_pages_to_sgt():89 size=4294352896
[  179.695000] vb2_dc_mmap: mapped dma addr 0x20000000 at 0xb695b000, size 614400
[  180.000000] mmc0: Too large timeout requested for CMD25!
[  180.075000] Entering vb2_dc_get_contiguous_size()
[  180.080000] sg_dma_address=0x20100000, sg_dma_len=393216
[  180.085000] expected=0x20160000
[  180.090000] Leaving vb2_dc_get_contiguous_size()
[  180.095000] vb2_dc_map_dmabuf():671contig_size=393216, buf->size=430080
[  180.100000] contiguous chunk is too small 393216/430080 b


--------------070200060801070106080701--
