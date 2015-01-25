Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:38069 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbbAYAuJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2015 19:50:09 -0500
Date: Sat, 24 Jan 2015 18:45:03 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Haim Daniel <haimdaniel@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] [pvrusb2]: remove dead retry cmd code
In-Reply-To: <54B8F7DC.6080401@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1501241844090.6191@cnc.isely.net>
References: <1420497518-10375-1-git-send-email-haim.daniel@gmail.com>  <54B8EE91.7020704@xs4all.nl> <1421407773.5847.1.camel@localhost.localdomain> <54B8F7DC.6080401@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Sorry been asleep at the wheel here.  I'll take a look.

Please realize that the code path being talked about here HAS worked - 
because the encoder does tend to fail and this is how the driver 
recovers.

  -Mike


On Fri, 16 Jan 2015, Hans Verkuil wrote:

> On 01/16/2015 12:29 PM, Haim Daniel wrote:
> > It looks that "if (try_count < 20) continue" jumps to end of the  do ...
> > while(0) loop and goes out.
> 
> Ah, you are right. But that is obviously not what was intended, so just removing
> it is not a proper 'fix'.
> 
> Mike, can you take a look at this?
> 
> Regards,
> 
> 	Hans
> 
> > 
> > --hd.
> > On Fri, 2015-01-16 at 11:57 +0100, Hans Verkuil wrote:
> >> On 01/05/2015 11:38 PM, Haim Daniel wrote:
> >>> In case a command is timed out, current flow sets the retry_flag
> >>> and does nothing.
> >>
> >> Really? That's not how I read the code: it retries up to 20 times before
> >> bailing out.
> >>
> >> Perhaps you missed the "if (try_count < 20) continue;" line?
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >>>
> >>> Signed-off-by: Haim Daniel <haim.daniel@gmail.com>
> >>> ---
> >>>  drivers/media/usb/pvrusb2/pvrusb2-encoder.c | 15 +--------------
> >>>  1 file changed, 1 insertion(+), 14 deletions(-)
> >>>
> >>> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
> >>> index f7702ae..02028aa 100644
> >>> --- a/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
> >>> +++ b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
> >>> @@ -145,8 +145,6 @@ static int pvr2_encoder_cmd(void *ctxt,
> >>>  			    u32 *argp)
> >>>  {
> >>>  	unsigned int poll_count;
> >>> -	unsigned int try_count = 0;
> >>> -	int retry_flag;
> >>>  	int ret = 0;
> >>>  	unsigned int idx;
> >>>  	/* These sizes look to be limited by the FX2 firmware implementation */
> >>> @@ -213,8 +211,6 @@ static int pvr2_encoder_cmd(void *ctxt,
> >>>  			break;
> >>>  		}
> >>>  
> >>> -		retry_flag = 0;
> >>> -		try_count++;
> >>>  		ret = 0;
> >>>  		wrData[0] = 0;
> >>>  		wrData[1] = cmd;
> >>> @@ -245,11 +241,9 @@ static int pvr2_encoder_cmd(void *ctxt,
> >>>  			}
> >>>  			if (rdData[0] && (poll_count < 1000)) continue;
> >>>  			if (!rdData[0]) {
> >>> -				retry_flag = !0;
> >>>  				pvr2_trace(
> >>>  					PVR2_TRACE_ERROR_LEGS,
> >>> -					"Encoder timed out waiting for us"
> >>> -					"; arranging to retry");
> >>> +					"Encoder timed out waiting for us");
> >>>  			} else {
> >>>  				pvr2_trace(
> >>>  					PVR2_TRACE_ERROR_LEGS,
> >>> @@ -269,13 +263,6 @@ static int pvr2_encoder_cmd(void *ctxt,
> >>>  			ret = -EBUSY;
> >>>  			break;
> >>>  		}
> >>> -		if (retry_flag) {
> >>> -			if (try_count < 20) continue;
> >>> -			pvr2_trace(
> >>> -				PVR2_TRACE_ERROR_LEGS,
> >>> -				"Too many retries...");
> >>> -			ret = -EBUSY;
> >>> -		}
> >>>  		if (ret) {
> >>>  			del_timer_sync(&hdw->encoder_run_timer);
> >>>  			hdw->state_encoder_ok = 0;
> >>>
> >>
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
