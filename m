Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51609 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbcKJIIQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 03:08:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Antti Palosaari <crope@iki.fi>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [RFC 5/5] doc_rst: media: New SDR formats SC16, SC18 & SC20
Date: Thu, 10 Nov 2016 10:08:17 +0200
Message-ID: <1805711.Tm0TqcXx1h@avalon>
In-Reply-To: <SG2PR06MB103893781A3AC3FAB8389DB8C3A20@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <9ec35a3a-02a7-8067-8f7c-23243de8456a@iki.fi> <SG2PR06MB103893781A3AC3FAB8389DB8C3A20@SG2PR06MB1038.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti, Hans, ping ? Please see below.

On Friday 04 Nov 2016 09:23:29 Ramesh Shanmugasundaram wrote:
> > On 11/02/2016 10:58 PM, Laurent Pinchart wrote:
> >> On Wednesday 02 Nov 2016 09:00:00 Ramesh Shanmugasundaram wrote:
> >>>>> On Wednesday 12 Oct 2016 15:10:29 Ramesh Shanmugasundaram wrote:
> >>>>> 
> >>>>>> This patch adds documentation for the three new SDR formats
> >>>>>>
> >>>>>> V4L2_SDR_FMT_SCU16BE
> >>>>>> V4L2_SDR_FMT_SCU18BE
> >>>>>> V4L2_SDR_FMT_SCU20BE
> >>>
> >>> [snip]
> >>>
> >>>>>> +
> >>>>>> +       -  start + 0:
> >>>>>> +
> >>>>>> +       -  I'\ :sub:`0[D13:D6]`
> >>>>>> +
> >>>>>> +       -  I'\ :sub:`0[D5:D0]`
> >>>>>> +
> >>>>>> +    -  .. row 2
> >>>>>> +
> >>>>>> +       -  start + buffer_size/2:
> >>>>>> +
> >>>>>> +       -  Q'\ :sub:`0[D13:D6]`
> >>>>>> +
> >>>>>> +       -  Q'\ :sub:`0[D5:D0]`
> >>>>>
> >>>>>
> >>>>>
> >>>>> The format looks planar, does it use one V4L2 plane (as does NV12)
> >>>>> or two V4L2 planes (as does NV12M) ? Same question for the other
> >>>>> formats.
> >>>>
> >>>> Thank you for bringing up this topic. This is one of the key design
> >>>> dilemma.
> >>>>
> >>>> The I & Q data for these three SDR formats comes from two different
> >>>> DMA channels and hence two separate pointers -> we could say it is
> >>>> v4l2 multi- planar. Right now, I am making it look like a single
> >>>> plane by presenting the data in one single buffer ptr.
> >>>>
> >>>> For e.g. multi-planar SC16 format would look something like this
> >>>>
> >>>> <------------------------32bits---------------------->
> >>>> <--I(14 bit data) + 2bit status--16bit padded zeros--> : start0 + 0
> >>>> <--I(14 bit data) + 2bit status--16bit padded zeros--> : start0 + 4
> >>>> ...
> >>>> <--Q(14 bit data) + 2bit status--16bit padded zeros--> : start1 + 0
> >>>> <--Q(14 bit data) + 2bit status--16bit padded zeros--> : start1 + 4
> >>>>
> >>>> My concerns are
> >>>>
> >>>> 1) These formats are not a standard as the video "Image Formats".
> >>>> These formats are possible when we use DRIF + MAX2175 combination.
> >>>> If we interface with a different tuner vendor, the above format(s)
> >>>> MAY/MAY NOT be re-usable. We do not know at this point. This is the
> >>>> main open item for discussion in the cover letter.
> >>
> >> If the formats are really device-specific then they should be
> >> documented accordingly and not made generic.
> >>
> >>>> 2) MPLANE support within V4L2 seems specific to video. Please
> >>>> correct me if this is wrong interpretation.
> >>>>
> >>>> - struct v4l2_format contains v4l2_sdr_format and
> >>>> v4l2_pix_format_mplane as members of union. Should I create a new
> >>>> v4l2_sdr_format_mplane? If I have to use v4l2_pix_format_mplane most
> >>>> of the video specific members would be unused (it would be similar
> >>>> to using v4l2_pix_format itself instead of v4l2_sdr_format)?
> >>
> >> I have no answer to that question as I'm not familiar with SDR. Antti,
> >> you've added v4l2_sdr_format to the API, what's your opinion ? Hans,
> >> as you've acked the patch, your input would be appreciated as well.
> > 
> > If I understood correctly this hardware provides I and Q samples via
> > different channels and driver now combines those channels as a sequential
> > IQ sample pairs. 
> 
> The driver combines the two buffer ptrs and present as one single buffer.
> For a buffer of size 200
>
> ptr + 0   : I I I I ... I
> ptr + 100 : Q Q Q Q ... Q
> 
> > I have never seen any other than hw which provides IQ IQ IQ IQ ... IQ.
> 
> There are some modes where this h/w combo can also do IQ IQ IQ pattern.
> Those modes are not added in the RFC patchset.
> 
> > This is
> > I I I I ... I
> > Q Q Q Q ... Q
> > I am not very familiar with planars, but it sounds like it is correct
> > approach. So I think should be added rather than emulate packet
> > sequential format.
> 
> My understanding of V4L2 MPLANE constructs is limited to a quick code read
> only. At this point MPLANE support seems specific to video. SDR is defined
> as separate format like v4l2_pix_format. Questions would be - should we
> define new SDR_MPLANE? or merge SDR format with pix format & reuse existing
> MPLANE with some SDR extensions (if possible)? These seem big design
> decisions. Any suggestions please?
>
> For my use case, MPLANE support does not seem to add significant benefit
> except it may be syntactically correct. I am doing cyclic DMA with a small
> set of h/w buffers and copying each stage to one mmapped vmalloc vb2_buffer
> at two offsets. If we add MPLANE support, it can be two non-contiguous
> buffer pointers. 
>
> >>>> - The above decision (accomodate SDR & MPLANE) needs to be
> >>>> propagated across the framework. Is this the preferred approach?
> >>>>
> >>>> It goes back to point (1). As of today, the change set for this
> >>>> combo (DRIF+MAX2175) introduces new SDR formats only. Should it add
> >>>> further SDR+MPLANE support to the framework as well?
> >>>>
> >>>> I would appreciate your suggestions on this regard.

-- 
Regards,

Laurent Pinchart

