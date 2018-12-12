Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD16C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 18:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9754120851
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 18:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9754120851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kwiboo.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbeLLS22 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:28:28 -0500
Received: from mail-oln040092065093.outbound.protection.outlook.com ([40.92.65.93]:39648
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727913AbeLLS22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 13:28:28 -0500
Received: from DB5EUR01FT007.eop-EUR01.prod.protection.outlook.com
 (10.152.4.59) by DB5EUR01HT078.eop-EUR01.prod.protection.outlook.com
 (10.152.5.51) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1425.16; Wed, 12 Dec
 2018 18:28:24 +0000
Received: from AM0PR03MB4676.eurprd03.prod.outlook.com (10.152.4.52) by
 DB5EUR01FT007.mail.protection.outlook.com (10.152.4.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1425.16 via Frontend Transport; Wed, 12 Dec 2018 18:28:24 +0000
Received: from AM0PR03MB4676.eurprd03.prod.outlook.com
 ([fe80::f02a:2a6f:1b3b:ee3e]) by AM0PR03MB4676.eurprd03.prod.outlook.com
 ([fe80::f02a:2a6f:1b3b:ee3e%3]) with mapi id 15.20.1404.026; Wed, 12 Dec 2018
 18:28:24 +0000
From:   Jonas Karlman <jonas@kwiboo.se>
To:     "hverkuil-cisco@xs4all.nl" <hverkuil-cisco@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        =?Windows-1252?Q?Jernej_=8Akrabec?= <jernej.skrabec@gmail.com>
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
Thread-Topic: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
Thread-Index: AQHUkheubL+OrDRAAUSQIXvjcD4iY6V7bRUA
Date:   Wed, 12 Dec 2018 18:28:23 +0000
Message-ID: <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0023.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::33) To AM0PR03MB4676.eurprd03.prod.outlook.com
 (2603:10a6:208:cc::33)
x-incomingtopheadermarker: OriginalChecksum:0B7601691A04E84AE1DE69A636C9BAB52B47193CDD2E392988C0B977897AACE3;UpperCasedChecksum:ECE74C73BF210C411B92C5CB5BE8412029B5EAB4420D414569344E952A100273;SizeAsReceived:7868;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [SzW7CPXxPUVwp9rPM86FtmPmpBlWT3ss]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB5EUR01HT078;6:KL9HCD7HRgW2q/nj+wGe5ywglcqkvWVl57Ms0DXxHXc1gQf6gANB9qm36ACg/+/Fqh8vI56JAboTpC+I2m3cNgASF+sAolfEFnt1cvib/MudNdKFqn8WDm85AJhQWDlf3epKwTe2NvL60KPiiU3cWXU3YnqIYGz/ejpAA3xOIz/3As7KKWm+ny60HYI79GMq1gaMDntt032G5q0/rwu2ZIxNYQVJzMhI+bDdDINCJSEgx6+5brwX2dQW965x88zRJazGKOOo6tFvgsGotZMaMFHBOKz2Rqy3Wb5kZO1ztDDFqwmMjo8wzMQgYG4KeR6rNMokIGlfTFGLA9Ajo5sSXbOx2DqYdBrqjz9Tn94PkZhoL/vz6+kDWCstWsSN/iuNjBGm3TYy1l8kz3YpMuQu6SdMHHWXshhrif1wuy+oraS7TsLqdCgcko5RsBRnT/ASS49HZherYPJ+0Byj50qNKQ==;5:HAXpUNhbIdoTAWxpIyQJZaEadjJ0Vutbn7HdKh0fNbsixURResyMdVwsWfI0Uk8TRLT1EKdI7fr2K/Oqbde4F9ui6HPN3KnEteOlIQvy9L5/IIfyikIuJiYQkZM40GJKKi19edY+QeniHzYI2pNsJRl/Xs3Pc+ZMOADS3v3iRww=;7:5nw3GPCQ1BuVesroF90iR9bok6HiUFUaqVsJtdQ9snKYoHc+0UYshLPMsleVTECh04tAhngjNJBMTuJfzUPF9tBPF7p8g885GqaePCl9kV7Tnm5qWfWT28rWbO8avCBMD74UNJFPIBzZmaMrzNfQKg==
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031324274)(2017031323274)(2017031322404)(1603101475)(1601125500)(1701031045);SRVR:DB5EUR01HT078;
x-ms-traffictypediagnostic: DB5EUR01HT078:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:DB5EUR01HT078;BCL:0;PCL:0;RULEID:;SRVR:DB5EUR01HT078;
x-microsoft-antispam-message-info: cI3nc0ipAPMJjfEIXhiEOyhky/z3F5IrKSjJyhAwyZMIr31SCHVc2o5lZST7dNw+
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <DF12A7CED9CAC746A518B1E215B36524@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9a24c9-93b0-4f7b-7067-08d6605f999a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 54485d23-c432-40fe-8436-6091d627118c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2018 18:28:23.9592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR01HT078
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Since this function only return DEQUEUED and DONE buffers,
it cannot be used to find a capture buffer that is both used for
frame output and is part of the frame reference list.
E.g. a bottom field referencing a top field that is already
part of the capture buffer being used for frame output.
(top and bottom field is output in same buffer)

Jernej Škrabec and me have worked around this issue in cedrus driver by
first checking
the tag/timestamp of the current buffer being used for output frame.


// field pictures may reference current capture buffer and is not
returned by vb2_find_tag
if (v4l2_buf->tag == dpb->tag)
    buf_idx = v4l2_buf->vb2_buf.index;
else
    buf_idx = vb2_find_tag(cap_q, dpb->tag, 0);


What is the recommended way to handle such case?
Could vb2_find_timestamp be extended to allow QUEUED buffers to be returned?


In our sample code we only keep at most one output, one capture buffer
in queue
and use buffer indices as tag/timestamp to simplify buffer handling.
FFmpeg keeps track of buffers/frames referenced and a buffer will not be
reused
until the codec and display pipeline have released all references to it.

Sample code having interlaced and multi-slice support using previous tag
version of this patchset can be found at:
https://github.com/jernejsk/LibreELEC.tv/blob/hw_dec_ffmpeg/projects/Allwinner/patches/linux/0025-H264-fixes.patch#L120-L124
https://github.com/Kwiboo/FFmpeg/compare/4.0.3-Leia-Beta5...v4l2-request-hwaccel

Regards,
Jonas

On 2018-12-12 13:38, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> Use v4l2_timeval_to_ns instead of timeval_to_ns to ensure that
> both kernelspace and userspace will use the same conversion
> function.
>
> Next add a new vb2_find_timestamp() function to find buffers
> with a specific timestamp.
>
> This function will only look at DEQUEUED and DONE buffers, i.e.
> buffers that are already processed.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 22 +++++++++++++++++--
>  include/media/videobuf2-v4l2.h                | 19 +++++++++++++++-
>  2 files changed, 38 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 1244c246d0c4..8d1231c2da65 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -143,7 +143,7 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
>  		 * and the timecode field and flag if needed.
>  		 */
>  		if (q->copy_timestamp)
> -			vb->timestamp = timeval_to_ns(&b->timestamp);
> +			vb->timestamp = v4l2_timeval_to_ns(&b->timestamp);
>  		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
>  		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
>  			vbuf->timecode = b->timecode;
> @@ -460,7 +460,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->flags = vbuf->flags;
>  	b->field = vbuf->field;
>  	b->timestamp = ns_to_timeval(vb->timestamp);
> -	b->timecode = vbuf->timecode;
> +	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
> +		b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
>  	b->reserved2 = 0;
>  	b->request_fd = 0;
> @@ -586,6 +587,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
>  	.copy_timestamp		= __copy_timestamp,
>  };
>  
> +int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
> +		       unsigned int start_idx)
> +{
> +	unsigned int i;
> +
> +	for (i = start_idx; i < q->num_buffers; i++) {
> +		struct vb2_buffer *vb = q->bufs[i];
> +
> +		if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
> +		     vb->state == VB2_BUF_STATE_DONE) &&
> +		    vb->timestamp == timestamp)
> +			return i;
> +	}
> +	return -1;
> +}
> +EXPORT_SYMBOL_GPL(vb2_find_timestamp);
> +
>  /*
>   * vb2_querybuf() - query video buffer information
>   * @q:		videobuf queue
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 727855463838..80f1afa0edad 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -32,7 +32,7 @@
>   *		&enum v4l2_field.
>   * @timecode:	frame timecode.
>   * @sequence:	sequence count of this frame.
> - * @request_fd:	the request_fd associated with this buffer
> + * @request_fd:	the request_fd associated with this buffer.
>   * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
>   *
>   * Should contain enough information to be able to cover all the fields
> @@ -55,6 +55,23 @@ struct vb2_v4l2_buffer {
>  #define to_vb2_v4l2_buffer(vb) \
>  	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
>  
> +/**
> + * vb2_find_timestamp() - Find buffer with given timestamp in the queue
> + *
> + * @q:		pointer to &struct vb2_queue with videobuf2 queue.
> + * @timestamp:	the timestamp to find. Only buffers in state DEQUEUED or DONE
> + *		are considered.
> + * @start_idx:	the start index (usually 0) in the buffer array to start
> + *		searching from. Note that there may be multiple buffers
> + *		with the same timestamp value, so you can restart the search
> + *		by setting @start_idx to the previously found index + 1.
> + *
> + * Returns the buffer index of the buffer with the given @timestamp, or
> + * -1 if no buffer with @timestamp was found.
> + */
> +int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
> +		       unsigned int start_idx);
> +
>  int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
>  
>  /**
