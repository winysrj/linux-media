Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38196 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730475AbeG0PX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 11:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <8c0b2fbec0302a15292d3629570ab1268fd306b8.camel@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-10-maxime.ripard@bootlin.com> <8c0b2fbec0302a15292d3629570ab1268fd306b8.camel@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 27 Jul 2018 22:01:28 +0800
Message-ID: <CAGb2v67k_bwATPiaRVifR0gnAaG56VztpW9WifOExQbLqm2Csg@mail.gmail.com>
Subject: Re: [PATCH 9/9] media: cedrus: Add H264 decoding support
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        nicolas.dufresne@collabora.com, Jens Kuske <jenskuske@gmail.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 27, 2018 at 9:56 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> Hi,
>
> On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
>> Introduce some basic H264 decoding support in cedrus. So far, only the
>> baseline profile videos have been tested, and some more advanced features
>> used in higher profiles are not even implemented.
>
> Here are two specific comments about things I noticed when going through
> the h264 code.
>
> [...]
>
>> @@ -88,12 +101,37 @@ struct sunxi_cedrus_ctx {
>>       struct work_struct run_work;
>>       struct list_head src_list;
>>       struct list_head dst_list;
>> +
>> +     union {
>> +             struct {
>> +                     void            *mv_col_buf;
>> +                     dma_addr_t      mv_col_buf_dma;
>> +                     ssize_t         mv_col_buf_size;
>> +                     void            *neighbor_info_buf;
>> +                     dma_addr_t      neighbor_info_buf_dma;
>
> Should be "neighbour" instead of "neighbor" and the same applies to most
> variables related to this, as well as the register description.

This just means you've been hanging out with people who use American
English. :)

ChenYu
