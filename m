Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:48319 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbZLHMYj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 07:24:39 -0500
Received: from [127.0.0.2] (helo=rzvpn18.informatik.uni-hamburg.de)
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <julian@jusst.de>)
	id 1NHz7U-0000MH-EN
	for linux-media@vger.kernel.org; Tue, 08 Dec 2009 13:24:44 +0100
Message-ID: <4B1E4587.3070304@jusst.de>
Date: Tue, 08 Dec 2009 13:24:39 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: New DVB(!!)-Statistics API
References: <4B1E1974.6000207@jusst.de>
In-Reply-To: <4B1E1974.6000207@jusst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.12.09 10:16, schrieb Julian Scheel:
> Hello together,
>
> after the last thread which asked about signal statistics details 
> degenerated into a discussion about the technical possibilites for 
> implementing an entirely new API, which lead to nothing so far, I 
> wanted to open a new thread to bring this forward. Maybe some more 
> people can give their votes for the different options
>
> Actually Manu did propose a new API for fetching enhanced statistics. 
> It uses new IOCTL to directly fetch the statistical data in one go 
> from the frontend. This propose was so far rejected by Mauro who wants 
> to use the S2API get/set calls instead.
>
> Now to give everyone a quick overview about the advantages and 
> disadvantages of both approaches I will try to summarize it up:
>
> 1st approach: Introduce new IOCTL
>
> Pros:
> - Allows a quick fetch of the entire dataset, which ensures that:
>  1. all values are fetched in one go (as long as possible) from the 
> frontend, so that they can be treated as one united and be valued in 
> conjunction
>  2. the requested values arrive the caller in an almost constant 
> timeframe, as the ioctl is directly executed by the driver
> - It does not interfere with the existing statistics API, which has to 
> be kept alive as it is in use for a long time already. (unifying it's 
> data is not the approach of this new API)
>
> Cons:
> - Forces the application developers to interact with two APIs. The 
> S2API for tuning on the one hand and the Statistics API for reading 
> signal values on the other hand.
>
> 2nd approach: Set up S2API calls for reading statistics
>
> Pros:
> - Continous unification of the linuxtv API, allowing all calls to be 
> made through one API. -> easy for application developers
>
> Cons:
> - Due to the key/value pairs used for S2API getters the statistical 
> values can't be read as a unique block, so we loose the guarantee, 
> that all of the values can be treatend as one unit expressing the 
> signals state at a concrete time.
> - Due to the general architecture of the S2API the delay between 
> requesting and receiving the actual data could become too big to allow 
> realtime interpretation of the data (as it is needed for applications 
> like satellite finders, etc.)
>
> I hope that this summary is technically correct in all points, if not 
> I'd be thankful for objective corrections. I am not going to 
> articulate my personal opinion in this mail, but I will do it in 
> another mail in reply to this one, so that this mail can be seen as a 
> neutral summary of the current situation.
>
> So now it's everyones turn to think about the options and give an 
> opinion. In the end I am quite sure that all of us would have great 
> benefits of an improved statistics API.
>
> Cheers,
> Julian
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The above mail of course has nothing to do with USB-Statistics. I must 
have been slightly confused when typing the message title! Sorry for that!
