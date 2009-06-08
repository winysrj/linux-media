Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator3.ecc.gatech.edu ([130.207.185.173]:54655 "EHLO
	deliverator3.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZFHVDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 17:03:24 -0400
Message-ID: <4A2D7C99.3090609@gatech.edu>
Date: Mon, 08 Jun 2009 17:03:21 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>	 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>	 <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>	 <4A2D4778.4090505@gatech.edu> <4A2D7277.7080400@kernellabs.com> <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
In-Reply-To: <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2009 04:36 PM, Devin Heitmueller wrote:
> On Mon, Jun 8, 2009 at 4:20 PM, Steven Toth<stoth@kernellabs.com>  wrote:
>    
>> We're getting into the realm of 'do you need to amplify and/or debug your
>> cable network', and out of the realm of driver development.
>>      
Comcast is coming tomorrow to check out the signal quality.  They said 
that they expect to deliver SNR in the range of 33dB - 45dB to the 
premises.  I will let you know how that affects Linux captures.
> Steven,
>
> One thing that is interesting is that he is getting BER/UNC errors
> even on ATSC, when he has a 30.2 dB signal.  While I agree that the
> cable company could be sending a weak signal, 30 dB should be plenty
> for ATSC.
>
> Also, it's possible that the playback application/codec in question
> poorly handles recovery from MPEG errors such as discontinuity, which
> results in the experience appearing to be worse under Linux.
>    
I am actually comparing the TS files captured under both Linux and 
Windows side-by-side in the same environment, copying the files to other 
computers in my home.  I can demux the video with Project-X which prints 
out the errors in the bitstream as it reads them.  I can also observe 
the overall quality by playing it back with VLC, WinDVD, etc.  When I 
use TMPGEnc Authoring Works 4 to read the file, the errors in the 
bitstream even seem to crash the application -- though obviously TMPGEnc 
is to blame for that.
> I'm going to see if I can find some cycles to do some testing here
> with s5h1409/s5h1411 and see if I can reproduce what David is seeing.
>
>    
Devin, I would really really appreciate this.  I hesitated to e-mail 
this list for several weeks, because I wanted to investigate thoroughly 
first and avoid wasting anyone's time as much as possible.  I hope you 
are able to reproduce this.

David
