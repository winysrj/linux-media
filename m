Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97DFdPe029276
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 09:15:40 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m97DFT4R027537
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 09:15:29 -0400
Received: by gxk8 with SMTP id 8so6523926gxk.3
	for <video4linux-list@redhat.com>; Tue, 07 Oct 2008 06:15:29 -0700 (PDT)
Message-ID: <ea3b75ed0810070615h59da2784pc77c3e99950a2041@mail.gmail.com>
Date: Tue, 7 Oct 2008 09:15:29 -0400
From: "Brian Phelps" <lm317t@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: capture.c example
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

Hi, I have a 4 input Hauppage ImpactVCB.

I have modified capture.c to display frames from an input using SDL
and the mmap method and this seems to work great.  I would like to
modify capture.c to display video using 2 inputs.  The problem is that
if I change inputs, I have to wait for another frame to enter the
buffer.  This cuts the frame rate in half.

How do I capture frames from two inputs without cutting the frame rate?


static void
mainloop                        (void)
{
   unsigned int count;

   count = 1000;

   //Frame_timer = SDL_AddTimer(INTERVAL, process_image, NULL);
   while (count-- > 0)
   {
      for (;;)
      {
         fd_set fds;
         struct timeval tv;
         int r;

         FD_ZERO (&fds);
         FD_SET (fd, &fds);

         /* Timeout. */
         tv.tv_sec = 2;
         tv.tv_usec = 0;

         r = select (fd + 1, &fds, NULL, NULL, &tv);

         if (-1 == r)
         {
            if (EINTR == errno)
               continue;

            errno_exit ("select");
         }

         if (0 == r)
         {
            fprintf (stderr, "select timeout\n");
            exit (EXIT_FAILURE);
         }

//         if (read_frame (0))
         {
            ;
            //r = select (fd + 1, &fds, NULL, NULL, &tv);
         }


         while(read_frame (0)==0)  // I modified read_frame to change
the input: read_frame(int input_number)
            r = select (fd + 1, &fds, NULL, NULL, &tv);

         while(read_frame (1)==0)
            r = select (fd + 1, &fds, NULL, NULL, &tv);
            break;

         /* EAGAIN - continue select loop. */
      }
      printf("Count is %d\n", count);
   }
}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
