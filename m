Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 1 Apr 2008 03:27:16 -0400
From: Alan Cox <alan@redhat.com>
To: Nicholas Magers <Nicholas.Magers@lands.nsw.gov.au>
Message-ID: <20080401072716.GA22496@devserv.devel.redhat.com>
References: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1C@SRV-QS-MAIL5.lands.nsw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1C@SRV-QS-MAIL5.lands.nsw>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com
Subject: Re: Dvico Dual 4 card not working.
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

On Tue, Apr 01, 2008 at 12:14:18PM +1100, Nicholas Magers wrote:
> I guess what I'm saying is in my naivety I mentioned the word 'Nvidia'.
> In all likelihood the problem has nothing to do with the 'Nvidia"
> component. I will in the future not mention the word 'Nvidia' so that my
> questions aren't railroaded to a dead end. Thanks for the valuable
> lesson.

Far more constructive would be to make sure you can reproduce bugs with the
"nv" driver - a lot of video playback and overlay bugs are heavily dependant
upon the X video driver and so things like Nvidia binary drivers cause problems
like those you reported

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
