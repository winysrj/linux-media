Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97DvgZe023888
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 09:57:42 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m97DvTKT020766
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 09:57:29 -0400
Received: by yx-out-2324.google.com with SMTP id 31so519298yxl.81
	for <video4linux-list@redhat.com>; Tue, 07 Oct 2008 06:57:29 -0700 (PDT)
Message-ID: <ea3b75ed0810070657i2f673bb1ub858b2871d7b387a@mail.gmail.com>
Date: Tue, 7 Oct 2008 09:57:28 -0400
From: "Brian Phelps" <lm317t@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: capture.c example (multiple inputs)
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

I did some digging and it looks like this single chip bt878 card must
cut the frame rate when switching inputs.  Is this correct?

I found a 4-chip version from bluecherry.com that seems to do this at
full 30 FPS per channel.

On Tue, Oct 7, 2008 at 9:15 AM, Brian Phelps <lm317t@gmail.com> wrote:
> Hi, I have a 4 input Hauppage ImpactVCB.
>
> I have modified capture.c to display frames from an input using SDL
> and the mmap method and this seems to work great.  I would like to
> modify capture.c to display video using 2 inputs.  The problem is that
> if I change inputs, I have to wait for another frame to enter the
> buffer.  This cuts the frame rate in half.
>
> How do I capture frames from two inputs without cutting the frame rate?
>
>
> static void
> mainloop                        (void)
> {
>   unsigned int count;
>
>   count = 1000;
>
>   //Frame_timer = SDL_AddTimer(INTERVAL, process_image, NULL);
>   while (count-- > 0)
>   {
>      for (;;)
>      {
>         fd_set fds;
>         struct timeval tv;
>         int r;
>
>         FD_ZERO (&fds);
>         FD_SET (fd, &fds);
>
>         /* Timeout. */
>         tv.tv_sec = 2;
>         tv.tv_usec = 0;
>
>         r = select (fd + 1, &fds, NULL, NULL, &tv);
>
>         if (-1 == r)
>         {
>            if (EINTR == errno)
>               continue;
>
>            errno_exit ("select");
>         }
>
>         if (0 == r)
>         {
>            fprintf (stderr, "select timeout\n");
>            exit (EXIT_FAILURE);
>         }
>
> //         if (read_frame (0))
>         {
>            ;
>            //r = select (fd + 1, &fds, NULL, NULL, &tv);
>         }
>
>
>         while(read_frame (0)==0)  // I modified read_frame to change
> the input: read_frame(int input_number)
>            r = select (fd + 1, &fds, NULL, NULL, &tv);
>
>         while(read_frame (1)==0)
>            r = select (fd + 1, &fds, NULL, NULL, &tv);
>            break;
>
>         /* EAGAIN - continue select loop. */
>      }
>      printf("Count is %d\n", count);
>   }
> }
>



-- 
Brian Phelps
System Design Engineer
Custom Light and Sound
919-286-0011
http://customlightandsound.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
