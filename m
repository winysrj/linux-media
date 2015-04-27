Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43928 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbbD0MSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 08:18:31 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	'Hans Verkuil' <hansverk@cisco.com>
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
 <1429794192-20541-7-git-send-email-k.debski@samsung.com>
 <553E0E86.4080002@xs4all.nl> <553E1D1A.9020503@xs4all.nl>
In-reply-to: <553E1D1A.9020503@xs4all.nl>
Subject: RE: [PATCH v4 06/10] cec: add HDMI CEC framework
Date: Mon, 27 Apr 2015 14:18:27 +0200
Message-id: <"08ee01d080e4$44c4c770$ce4e5650$@debski"@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you so much for all today's comments. I will consider them when
preparing the next version.

From: linux-media-owner@vger.kernel.org [mailto:linux-media-
owner@vger.kernel.org] On Behalf Of Hans Verkuil
Sent: Monday, April 27, 2015 1:27 PM
> 
> On 04/27/2015 12:25 PM, Hans Verkuil wrote:
> > On 04/23/2015 03:03 PM, Kamil Debski wrote:
> >> From: Hans Verkuil <hansverk@cisco.com>
> >>
> >> The added HDMI CEC framework provides a generic kernel interface for
> >> HDMI CEC devices.
> >>
> >> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> >> [k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
> >> [k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
> >> [k.debski@samsung.com: change kthread handling when setting logical
> >> address]
> >> [k.debski@samsung.com: code cleanup and fixes]
> >> [k.debski@samsung.com: add missing CEC commands to match spec]
> >> [k.debski@samsung.com: add RC framework support]
> >> [k.debski@samsung.com: move and edit documentation]
> >> [k.debski@samsung.com: add vendor id reporting]
> >> [k.debski@samsung.com: add possibility to clear assigned logical
> >> addresses]
> >> [k.debski@samsung.com: documentation fixes, clenaup and expansion]
> >> [k.debski@samsung.com: reorder of API structs and add reserved
> >> fields]
> >> [k.debski@samsung.com: fix handling of events and fix 32/64bit
> >> timespec problem]
> >> [k.debski@samsung.com: add cec.h to include/uapi/linux/Kbuild]
> >> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> >> ---
> >>  Documentation/cec.txt     |  396 ++++++++++++++++
> >>  drivers/media/Kconfig     |    6 +
> >>  drivers/media/Makefile    |    2 +
> >>  drivers/media/cec.c       | 1161
> +++++++++++++++++++++++++++++++++++++++++++++
> >>  include/media/cec.h       |  140 ++++++
> >>  include/uapi/linux/Kbuild |    1 +
> >>  include/uapi/linux/cec.h  |  303 ++++++++++++
> >>  7 files changed, 2009 insertions(+)
> >>  create mode 100644 Documentation/cec.txt  create mode 100644
> >> drivers/media/cec.c  create mode 100644 include/media/cec.h  create
> >> mode 100644 include/uapi/linux/cec.h
> >>
> >
> >> +	case CEC_S_ADAP_LOG_ADDRS: {
> >> +		struct cec_log_addrs log_addrs;
> >> +
> >> +		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
> >> +			return -ENOTTY;
> >> +		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
> >> +			return -EFAULT;
> >> +		err = cec_claim_log_addrs(adap, &log_addrs, true);
> >
> > Currently CEC_S_ADAP_LOG_ADDRS is always blocking, but since we have
> > CEC_EVENT_READY I think it makes sense to just return in non-blocking
> > mode and have cec_claim_log_addrs generate CEC_EVENT_READY when done.
> > Userspace can then call G_ADAP_LOG_ADDRS to discover the result.
> >
> > What do you think?
> >

I am looking into this now. If I see this correctly this involves:
- adding cec_post_event(cla_int->adap, CEC_EVENT_READY); to
cec_config_thread_func
- adding O_NONBLOCK check in CEC_S_ADAP_LOG_ADDRS 
Right?
 
> On a related topic: non-blocking behavior for CEC_RECEIVE is well
> defined, but for CEC_TRA NSMIT it isn't. If reply == 0, then we need a
> way to inform userspace that the transmit finished (with a possible
> non-zero status code). An event would be suitable for that, but we
> would need a way to associate a transmit message with the event.
> 
> One possibility might be to have the CEC framework assign a sequence
> number to a transmit message which is returned by CEC_TRANSMIT and used
> in the event.
> 
> If reply != 0, then I think the received message should be queued up in
> the receive queue, but with a non-zero reply field and with the
> sequence number of the transmit message it is a reply of.

A sequence number is a good solution, I believe. To recap:
- a sequence number should be set by the framework and returned in the
CEC_TRANSMIT ioctl
- a new event should be added CEC_EVENT_TX_DONE and it should be posted on
each transmission
  finish 
- event struct has to include a sequence field as well
Is this ok?

> 
> Regards,
> 
> 	Hans

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

