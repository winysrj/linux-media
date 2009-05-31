Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp113.rog.mail.re2.yahoo.com ([68.142.225.229]:43398 "HELO
	smtp113.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751412AbZEaSKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 14:10:41 -0400
Message-ID: <4A22C691.1000100@rogers.com>
Date: Sun, 31 May 2009 14:04:01 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgxaB1c3Rlaw==?= <sustmidown@centrum.cz>
CC: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
References: <200905291628.32305@centrum.cz> <200905291629.364@centrum.cz> <200905291630.21607@centrum.cz> <200905291631.1309@centrum.cz> <200905291632.13608@centrum.cz> <200905291632.28450@centrum.cz>
In-Reply-To: <200905291632.28450@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Miroslav Šustek wrote:
> Any problem with this patch?
> I'm trying to get WinFast DTV-1800H support into repository for seven months.
> (see:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/1125/match=1800h
>
>   

Hi Miro,

Its unfortunate that the patch hasn't been added yet, but I do see a
problem (in its current form) that explains why it hasn't been picked
up.   For the sake of thoroughness, here's an audit trail of the entire
history:

1) http://linuxtv.org/pipermail/linux-dvb/2008-October/029859.html
- Steve picked up some style flaws
- (Although it is more desirable to include patches inline as opposed to
as attachments, I note that the attached patch is of type
"text/x-patch", which is fine)

2) http://linuxtv.org/pipermail/linux-dvb/2008-November/030362.html
- I noticed your missing SOB
- (Again, I note that the attached patch is of type "text/x-patch",
which is fine)

3)
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/1125/match=1800h
- You note in your message that your prior patch didn't get picked up
possibly because of the switch of mail lists.  That is quite possible,
but whatever the case, your patch was, indeed, lost.
- Herman responded with some suggestions, as well as noting that your
SOB was absent again with the attached patches (though, I know you had
resubmitted back in Nov with a SOB)
- But here starts the most recent problem: unfortunately, the attached
patches where of type "application/octet-stream", which the patchwork
tool will NOT pick up.  Please see:
http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
This is a summary explanation of the submitting process (which includes
links to several of the documents you've undoubtedly already read) and
touches upon attachments.

4) http://www.mail-archive.com/linux-media@vger.kernel.org/msg05856.html
-  in Hermann's follow up, he correctly notes that the patches never
made it onto the patchwork queue (see my explanation directly above for
why they were not).

5) http://www.mail-archive.com/linux-media@vger.kernel.org/msg05888.html
> Nobody noticed the previous post(s).
>   
- Ha, I beg to differ! -- at the very least, Steve, myself and Hermann
have all spotted your prior patches and have commented.
- Unfortunately, the attached patch is again of the type
"application/octet-stream" and will NOT be automatically picked up by
patchwork


6) http://www.mail-archive.com/linux-media@vger.kernel.org/msg05890.html
> (Shoot me! Now it's correct.)
>   
- Nope.  The attached patch is still a type "application/octet-stream",
and that is why it is not showing up on the patchwork queue list
- I have also just noticed that Trent has also now commented on the
patches (so add another to the list!)

/End of audit trail

I understand your frustration and I don't mean to be bureaucratic (I
have zero say in what patches get picked up), but I hope I have shed
some light upon what has gone wrong over the last several months. 
Although I'd rather suspect that Mauro is now well aware of the issue,
I'd urge you to resubmit (following the recommendations from the link I
provided above) so that it gets picked up and placed upon the patchwork
list.




