Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:41611 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab3CFPac convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 10:30:32 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Wed, 6 Mar 2013 07:30:08 -0800
Subject: RE: [REVIEW PATCH V4 12/12] [media] marvell-ccic: add 3 frame
 buffers support in DMA_CONTIG mode
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D8DAA98@SC-VEXCH1.marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-13-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051515590.25837@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D9D8DAA8F@SC-VEXCH1.marvell.com>
 <Pine.LNX.4.64.1303061600420.7010@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1303061600420.7010@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 06 March, 2013 23:02
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: RE: [REVIEW PATCH V4 12/12] [media] marvell-ccic: add 3 frame buffers
>support in DMA_CONTIG mode
>
>On Wed, 6 Mar 2013, Albert Wang wrote:
>
>[snip]
>
>> >> +		if (cam->frame_state.usebufs == 0)
>> >> +			cam->frame_state.usebufs++;
>> >> +		else {
>> >> +			set_bit(CF_SINGLE_BUFFER, &cam->flags);
>> >> +			cam->frame_state.singles++;
>> >> +			if (cam->frame_state.usebufs < 2)
>> >> +				cam->frame_state.usebufs++;
>> >
>> >What is this .usebufs actually supposed to do? AFAICS, it is only used to
>> >decide, whether it should be changed, I don't see it having any effect on
>> >anything else?
>> >
>> Actually, we use .usebufs to decide if will enter single buffer mode.
>> Only usebufs == 2 can enter single buffer mode.
>> But when init it:
>> 	If CCIC use Two Buffers mode, init usebufs == 1
>> 	If CCIC use Three Buffers mode, init usebufs == 0
>> That means when CCIC use Two Buffers mode, once buffer used out, CCIC will enter
>single buffer mode soon
>> But when CCIC use Three Buffers mode, we can have 1 frame time to wait for
>> new buffer and needn't enter single buffer mode.
>> If we still can't get new buffer after 1 frame, then CCIC has to enter single buffer mode.
>> But if we are lucky enough and get new buffer when next frame come, then
>> we can still run in normal mode.
>
>Thanks for the explanation. Could you please tell me where in the code
>this .usebufs field is used as you describe?
>
Firstly, we will init this field, the initial value depends on selected CCIC buffer mode:
+	/*
+	 *  If CCIC use Two Buffers mode, init usebufs == 1
+	 *  If CCIC use Three Buffers mode, init usebufs == 0
+	 */
+	cam->frame_state.usebufs = 3 - MAX_FRAME_BUFS;

Then:
		/*
+		 * If there are no available buffers
+		 * go into single buffer mode
+		 *
But it depends on usebufs state:
+		if (cam->frame_state.usebufs == 0)
+			cam->frame_state.usebufs++;
+		else {
+			set_bit(CF_SINGLE_BUFFER, &cam->flags);
+			cam->frame_state.singles++;
+			if (cam->frame_state.usebufs < 2)
+				cam->frame_state.usebufs++;
+		}
usebufs range is 0, 1, 2:
0 - Use Three buffer mode, and CCIC needn't enter single buffer mode when buffer used out in the first time
1 - Use Two buffer mode and CCIC need enter single buffer mode
   Or Use Three buffer mode and CCIC also need enter single buffer mode when we still can't get new buffer after continuous 2 frames
2 - CCIC had enterer single buffer mode whatever use Two buffer or Three buffer mode

And if:
		/*
 		 * OK, we have a buffer we can use.

We will exit the single buffer mode:

		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
+		if (cam->frame_state.usebufs != (3 - MAX_FRAME_BUFS))
+			cam->frame_state.usebufs--;
 	}
And we will try to let usebufs back to initial value.



>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Thanks
Albert Wang
86-21-61092656
