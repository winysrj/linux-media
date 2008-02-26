Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <47C4488A.8080107@mediaxim.be>
Date: Tue, 26 Feb 2008 18:12:42 +0100
From: Michel Bardiaux <mbardiaux@mediaxim.be>
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
	<20080226133839.GE26389@devserv.devel.redhat.com>
	<47C440FB.8080705@mediaxim.be>
	<20080226170215.GB4682@devserv.devel.redhat.com>
In-Reply-To: <20080226170215.GB4682@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Grabbing 4:3 and 16:9
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Alan Cox wrote:
> On Tue, Feb 26, 2008 at 05:40:27PM +0100, Michel Bardiaux wrote:
>> credits on the captured MPEGs). But Daniel wrote that the 16:9 analog 
>> broadcasts have only 432 lines, so the info is not there in the first 
>> place. So that effect isnt an option for me. But thanks anyway.
> 
> Per frame.... if you sample as it scrolls and line up the title tops I suspect
> most of the time you can get more samples as the title moves.
> 
Not crazy, I am *also* considering various image enhancement techniques, 
I just want to start from the best possible capture in the first place. 
That means capturing at 768(or more?) wide instead of 704; in YUV422P 
instead of YUV420P; avoiding reizing, and use better resizing 
algorithms. And capturing at 576 instead of 432 vertically would help too.

As I find more relevant pages, my question has now become: given a 
768x576 capture (by a BT878) can I check whether the PALPLUS is there? 
No use trying to implement the decoder in software if the signal simply 
isnt there!

-- 
Michel Bardiaux
R&D Director
T +32 [0] 2 790 29 41
F +32 [0] 2 790 29 02
E mailto:mbardiaux@mediaxim.be

Mediaxim NV/SA
Vorstlaan 191 Boulevard du Souverain
Brussel 1160 Bruxelles
http://www.mediaxim.com/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
