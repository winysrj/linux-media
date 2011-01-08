Return-path: <mchehab@pedra>
Received: from mail3.lastar.com ([74.84.105.102]:49289 "EHLO mail.lastar.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751195Ab1AHUpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 15:45:35 -0500
From: Jason Gauthier <jgauthier@lastar.com>
To: Andy Walls <awalls@md.metrocast.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: zilog and IR
Date: Sat, 8 Jan 2011 20:34:29 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A0B686064@V-EXMAILBOX.ctg.com>
References: <AANLkTi=yLo8A==TXLYN6g72RZVsk4ydQthf29=i=A36j@mail.gmail.com>,<1294499977.2443.106.camel@localhost>
In-Reply-To: <1294499977.2443.106.camel@localhost>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On Sat, 2011-01-08 at 10:44 -0500, Jason Gauthier wrote:
>> Andy,
>>
>>    Firstly, I apologize for reaching out to you directly.

>The list could have answered this, so I adding the Cc:.

At the time of my searches, and the results, it was not apparent to me there was any mailing list associated with the information I uncovered.
I'm not a member, and this response might not be allowed.

>BTW, I normally ignore direct emails asking for free support, as the
>N-to-1 free support problem is too costly for me personally.  The N-to-M
>free support problem on the list is a little easier to bear, and is
>consistent with Linux's community development model.

There isn't any more agreement I can have on the N-to-1 model (see above!)

>>  I stumbled into your git tree, which looks like it does exactly what
>> I want.

>But it doesn't.  It's a bleeding edge tree of mine used to develop a
>changeset.  Be warned that such trees come with no guarantees that at
>any one moment in time it will compile and not damage your hardware.

I don't remember any part of Linux coming with a guarantee (other than having fun) ;)

>I only subjected the changes to personal review, compilation check, and
>inspection by others on the list.  That was sufficient for me for
>software defect removal, since the change was a cut-and-paste from the
>cx18 and ivtv modules and the code is not yet called by hdpvr anyway.

Noted!

>> I grabbed the source but, unfortunately, it is not compiling for me
>> because one of the constants is not defined.
>>
>> in hdprv_new_i2c_ir, the line:
>>     init_data->type = RC_TYPE_RC5;

>> I have not been able to find any traces of RC_TYPE_RC5 in my 2.6.37
>> kernel source.
>> Is this a #define that you've made specific to your git tree?

>No:

>http://git.linuxtv.org/media_tree.git?a=commit;h=e58462f45e39e01799d8b1ebab4816bd0ca68ddc

>That media_tree.git repository is the bleeding edge tree recommended for
>developers and advanced users wanting the latest drivers.

I found the #define in the git tree. It was in rc-media.h

>The alternate is the media_build.git repository when has ability to
>build the modules with some not so old kernels.

Again, thanks for your response!   
I am going to sub to the list, and do some follow up if I haven't been successful.

Jason

