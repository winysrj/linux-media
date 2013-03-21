Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab3CUNYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:24:18 -0400
Date: Thu, 21 Mar 2013 10:24:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] siano: remove the remaining CamelCase compliants
Message-ID: <20130321102403.23a7aee8@redhat.com>
In-Reply-To: <87d2usj3ho.fsf@nemi.mork.no>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
	<1363870963-28552-4-git-send-email-mchehab@redhat.com>
	<87d2usj3ho.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Mar 2013 14:18:11 +0100
Bjørn Mork <bjorn@mork.no> escreveu:

> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > Remove the remaining CamelCase checkpatch.pl compliants.
> > There are still a few left, but those are due to USB and
> > DVB APIs.
> [..]
> > @@ -840,31 +840,31 @@ int smscore_configure_board(struct smscore_device_t *coredev)
> >  	}
> >  
> >  	if (board->mtu) {
> > -		struct sms_msg_data MtuMsg;
> > +		struct sms_msg_data mtu_msg;
> >  		sms_debug("set max transmit unit %d", board->mtu);
> >  
> > -		MtuMsg.x_msg_header.msg_src_id = 0;
> > -		MtuMsg.x_msg_header.msg_dst_id = HIF_TASK;
> > -		MtuMsg.x_msg_header.msg_flags = 0;
> > -		MtuMsg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> > -		MtuMsg.x_msg_header.msg_length = sizeof(MtuMsg);
> > -		MtuMsg.msgData[0] = board->mtu;
> > +		mtu_msg.x_msg_header.msg_src_id = 0;
> > +		mtu_msg.x_msg_header.msg_dst_id = HIF_TASK;
> > +		mtu_msg.x_msg_header.msg_flags = 0;
> > +		mtu_msg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> > +		mtu_msg.x_msg_header.msg_length = sizeof(mtu_msg);
> > +		mtu_msg.msg_data[0] = board->mtu;
> >  
> 
> Ah, right.  Why don't you just squash patch 1 and 4 together, reducing
> the set with about the size of patch 4, and making all this somewhat
> more meaningful?
> 
> Tounching the exact same lines twice in the same patchset, doing the
> exact same type of cleanup, does *not* help review.

Yeah, but I was afraid that symbol conflicts would rise with those changes,
as a core API namespace could be matching some locale namespace.

If this happens, by having it into two separate patches help to debug
and fix.

Regards,
Mauro
