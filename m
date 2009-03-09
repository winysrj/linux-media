Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:63779 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZCIUnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 16:43:43 -0400
Message-ID: <49B57F7D.1020108@kaiser-linux.li>
Date: Mon, 09 Mar 2009 21:43:41 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Anders Blomdell <anders.blomdell@control.lth.se>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Topro 6800 driver
References: <49A8661A.4090907@control.lth.se>	<49B194A7.4030808@kaiser-linux.li>	<49B50740.3000902@control.lth.se>	<49B50E16.8080703@kaiser-linux.li> <49B56542.1090408@control.lth.se> <49B57799.3020504@kaiser-linux.li> <49B57C1D.3060600@control.lth.se>
In-Reply-To: <49B57C1D.3060600@control.lth.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anders

Anders Blomdell wrote:
> Thomas Kaiser wrote:
>>  > And a 640*480 image divided in 8*8 subframes gives (640*480/(8*8)) 1200
>>  > subframes, so now the question is how much info about the Huffman 
>> table this
>>  > gives us?
>>
>> I think nothing :-( , but you found the MCUs :-) As it looks quite the 
>> same as on the PAC7311, why not just try the Huffman table from the PAC7311?
> Which seems to be encoded in the stream and not defined in the sourcecode (but
> I'm tired, so I might well be wrong). Do you think you could extract it somehow?

I think it should be in the gspca source or in the v4l_library? I didn't 
follow gspca code and v4l_library code lately. Anyway PAC7311 is working 
AFAIK.

I'll check and try.

Thomas
