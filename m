Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab3CUNUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:20:24 -0400
Date: Thu, 21 Mar 2013 10:20:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] siano: get rid of CammelCase from smscoreapi.h
Message-ID: <20130321102016.07c8e31e@redhat.com>
In-Reply-To: <87hak4j3ue.fsf@nemi.mork.no>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
	<87hak4j3ue.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Mar 2013 14:10:33 +0100
Bjørn Mork <bjorn@mork.no> escreveu:

> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > It is almost impossible to see a compliant with checkpatch.pl
> > on those Siano drivers, as there are simply too much violations
> > on it. So, now that a big change was done, the better is to
> > cleanup the checkpatch compliants.
> >
> > Let's first replace all CammelCase symbols found at smscoreapi.h
> > using camel_case namespace. That removed 144 checkpatch.pl
> > compliants on this file. Of course, the other files need to be
> > fixed accordingly.
> [..]
> > @@ -840,14 +840,14 @@ int smscore_configure_board(struct smscore_device_t *coredev)
> >  	}
> >  
> >  	if (board->mtu) {
> > -		struct SmsMsgData_ST MtuMsg;
> > +		struct sms_msg_data MtuMsg;
> >  		sms_debug("set max transmit unit %d", board->mtu);
> >  
> > -		MtuMsg.xMsgHeader.msgSrcId = 0;
> > -		MtuMsg.xMsgHeader.msgDstId = HIF_TASK;
> > -		MtuMsg.xMsgHeader.msgFlags = 0;
> > -		MtuMsg.xMsgHeader.msgType = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> > -		MtuMsg.xMsgHeader.msgLength = sizeof(MtuMsg);
> > +		MtuMsg.x_msg_header.msg_src_id = 0;
> > +		MtuMsg.x_msg_header.msg_dst_id = HIF_TASK;
> > +		MtuMsg.x_msg_header.msg_flags = 0;
> > +		MtuMsg.x_msg_header.msg_type = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
> > +		MtuMsg.x_msg_header.msg_length = sizeof(MtuMsg);
> >  		MtuMsg.msgData[0] = board->mtu;
> >  
> >  		coredev->sendrequest_handler(coredev->context, &MtuMsg,
> 
> 
> 
> etc.  This didn't help one bit, did it?  There are exacly the same
> number of CamelCased lines here as before your patch.  Why is that?

I did this change in parts. This first patch changes only the symbols at
the structures defined in smscoreapi.h. Latter patches in this series fix
the rest.

I decided to do this way as not all CamelCase issues can be solved: there are
lots of CamelCase on Kernel's USB API (probably to match the USB standard?).

So, I can't simply blind run my CamelCase fix script when fixing the
remaining issues.

-- 

Cheers,
Mauro
